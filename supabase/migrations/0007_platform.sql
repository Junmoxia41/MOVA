-- MOVA · 0007 · subscriptions, notifications, app_config, audit_logs, sync_metadata

-- §41: registro del pago, no pasarela. El mecanismo real se decide después.
create table if not exists public.subscriptions (
  id                uuid primary key default gen_random_uuid(),
  driver_id         uuid not null references public.drivers (id) on delete cascade,
  plan_id           uuid not null references public.driver_plans (id) on delete restrict,
  status            public.subscription_status not null default 'PENDING_PAYMENT',
  amount            numeric(12, 2) not null default 0 check (amount >= 0),
  currency          text not null default 'CUP',
  start_date        date not null default current_date,
  end_date          date not null,
  payment_reference text,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now(),
  constraint subscriptions_range check (end_date > start_date)
);

create index if not exists ix_subscriptions_driver on public.subscriptions (driver_id, end_date desc);

create trigger trg_subscriptions_updated_at
  before update on public.subscriptions
  for each row execute function public.set_updated_at();

-- §46: notificaciones locales en V1; push queda preparado pero sin proveedor.
create table if not exists public.notifications (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references public.profiles (id) on delete cascade,
  kind        text not null,
  title       text not null,
  body        text,
  payload     jsonb not null default '{}'::jsonb,
  read_at     timestamptz,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  constraint notifications_kind_len check (char_length(kind) between 1 and 60)
);

create index if not exists ix_notifications_user
  on public.notifications (user_id, created_at desc);

create trigger trg_notifications_updated_at
  before update on public.notifications
  for each row execute function public.set_updated_at();

-- §58: configuración remota. NUNCA se usa para decisiones de seguridad.
create table if not exists public.app_config (
  key         text primary key,
  value       jsonb not null,
  description text,
  updated_by  uuid references public.profiles (id) on delete set null,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

comment on table public.app_config is
  'Mensajes, planes, promociones, flags, minimum_supported_version, latest_version, mantenimiento.';

create trigger trg_app_config_updated_at
  before update on public.app_config
  for each row execute function public.set_updated_at();

-- §83: auditoría de acciones administrativas (quién, qué, cuándo, resultado)
-- Append-only a propósito: sin updated_at ni trigger de actualización ni política
-- de UPDATE/DELETE por API. Un registro de auditoría mutable no sirve como auditoría.
create table if not exists public.audit_logs (
  id          bigint generated always as identity primary key,
  actor_id    uuid references public.profiles (id) on delete set null,
  action      text not null,
  entity      text not null,
  entity_id   text,
  result      text not null,
  detail      jsonb not null default '{}'::jsonb,
  created_at  timestamptz not null default now()
);

create index if not exists ix_audit_logs_actor on public.audit_logs (actor_id, created_at desc);
create index if not exists ix_audit_logs_entity on public.audit_logs (entity, created_at desc);

-- §15: metadatos de sincronización por dispositivo (la cola vive en Room;
-- aquí se guarda el punto de sincronización para detectar conflictos)
create table if not exists public.sync_metadata (
  id                 uuid primary key default gen_random_uuid(),
  user_id            uuid not null references public.profiles (id) on delete cascade,
  device_id          text not null,
  entity             text not null,
  last_synced_at     timestamptz,
  last_server_version bigint not null default 0,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  constraint sync_metadata_unique unique (user_id, device_id, entity)
);

create trigger trg_sync_metadata_updated_at
  before update on public.sync_metadata
  for each row execute function public.set_updated_at();

-- RLS
alter table public.subscriptions enable row level security;
alter table public.notifications enable row level security;
alter table public.app_config enable row level security;
alter table public.audit_logs enable row level security;
alter table public.sync_metadata enable row level security;

drop policy if exists subscriptions_select on public.subscriptions;
create policy subscriptions_select on public.subscriptions
  for select using (
    public.is_admin()
    or exists (select 1 from public.drivers d
               where d.id = driver_id and d.profile_id = auth.uid())
  );

drop policy if exists subscriptions_admin on public.subscriptions;
create policy subscriptions_admin on public.subscriptions
  for all using (public.is_admin()) with check (public.is_admin());

drop policy if exists notifications_own on public.notifications;
create policy notifications_own on public.notifications
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

-- app_config: lectura pública, escritura solo admin
drop policy if exists app_config_select on public.app_config;
create policy app_config_select on public.app_config for select using (true);

drop policy if exists app_config_admin on public.app_config;
create policy app_config_admin on public.app_config
  for all using (public.is_admin()) with check (public.is_admin());

-- audit_logs: solo lectura admin; nadie borra ni edita por API
drop policy if exists audit_logs_admin on public.audit_logs;
create policy audit_logs_admin on public.audit_logs
  for select using (public.is_admin());

drop policy if exists sync_metadata_own on public.sync_metadata;
create policy sync_metadata_own on public.sync_metadata
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());
