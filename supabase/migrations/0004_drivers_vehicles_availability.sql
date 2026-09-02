-- MOVA · 0004 · drivers, vehicles, driver_availability

create table if not exists public.drivers (
  id                   uuid primary key default gen_random_uuid(),
  profile_id           uuid not null unique references public.profiles (id) on delete cascade,
  display_name         text not null,
  photo_url            text,
  phone                text,
  description          text,
  verification_status  public.verification_status not null default 'PENDING',
  active               boolean not null default false,
  plan_id              uuid references public.driver_plans (id) on delete set null,
  rating               numeric(3, 2) not null default 0 check (rating >= 0 and rating <= 5),
  review_count         integer not null default 0 check (review_count >= 0),
  -- Optimista: base para la resolución de conflictos (§18)
  version              integer not null default 1,
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now(),
  constraint drivers_display_name_len check (char_length(display_name) between 1 and 120),
  constraint drivers_description_len check (description is null or char_length(description) <= 1000)
);

comment on table public.drivers is 'Perfil público del conductor (§27).';

create index if not exists ix_drivers_verification on public.drivers (verification_status, active);
create index if not exists ix_drivers_plan on public.drivers (plan_id);
create index if not exists ix_drivers_rating on public.drivers (rating desc);

create trigger trg_drivers_updated_at
  before update on public.drivers
  for each row execute function public.set_updated_at();

create table if not exists public.vehicles (
  id          uuid primary key default gen_random_uuid(),
  driver_id   uuid not null references public.drivers (id) on delete cascade,
  type        public.vehicle_type not null,
  brand       text,
  model       text,
  color       text,
  capacity    integer check (capacity is null or capacity > 0),
  description text,
  active      boolean not null default true,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  constraint vehicles_description_len check (description is null or char_length(description) <= 500)
);

comment on table public.vehicles is 'Vehículos del conductor (§28).';

create index if not exists ix_vehicles_driver on public.vehicles (driver_id);
create index if not exists ix_vehicles_type on public.vehicles (type) where active;

create trigger trg_vehicles_updated_at
  before update on public.vehicles
  for each row execute function public.set_updated_at();

-- Disponibilidad declarada por el conductor; NO es GPS (§29)
create table if not exists public.driver_availability (
  id            uuid primary key default gen_random_uuid(),
  driver_id     uuid not null references public.drivers (id) on delete cascade,
  weekday       smallint not null check (weekday between 0 and 6),
  start_minute  smallint not null check (start_minute between 0 and 1439),
  end_minute    smallint not null check (end_minute between 0 and 1440),
  status        public.availability_status not null default 'AVAILABLE',
  note          text,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  constraint driver_availability_window check (end_minute > start_minute)
);

comment on table public.driver_availability is
  'Mi Agenda: horario semanal del conductor (§30). weekday 0 = lunes.';

create index if not exists ix_availability_driver
  on public.driver_availability (driver_id, weekday);

create trigger trg_driver_availability_updated_at
  before update on public.driver_availability
  for each row execute function public.set_updated_at();

-- RLS (§24): el conductor gestiona lo suyo; nadie más.
alter table public.drivers enable row level security;
alter table public.vehicles enable row level security;
alter table public.driver_availability enable row level security;

drop policy if exists drivers_select on public.drivers;
create policy drivers_select on public.drivers
  for select using (
    public.is_admin()
    or (verification_status = 'VERIFIED' and active = true)
    or profile_id = auth.uid()
  );

drop policy if exists drivers_insert_own on public.drivers;
create policy drivers_insert_own on public.drivers
  for insert with check (profile_id = auth.uid());

drop policy if exists drivers_update_own on public.drivers;
create policy drivers_update_own on public.drivers
  for update using (profile_id = auth.uid() or public.is_admin())
  with check (profile_id = auth.uid() or public.is_admin());

-- La verificación la cambia SOLO admin (§38). RLS es por fila, no por columna,
-- así que se protege el campo con un trigger: sin él, un conductor podría
-- auto-verificarse actualizando su propia fila.
create or replace function public.guard_driver_verification()
returns trigger
language plpgsql
as $$
begin
  if new.verification_status is distinct from old.verification_status
     and not public.is_admin() then
    raise exception 'solo un administrador puede cambiar verification_status';
  end if;
  -- El conductor no puede reactivarse si fue suspendido por un admin
  if old.verification_status = 'SUSPENDED'
     and new.verification_status <> 'SUSPENDED'
     and not public.is_admin() then
    raise exception 'un conductor suspendido solo lo reactiva un administrador';
  end if;
  return new;
end;
$$;

drop trigger if exists trg_drivers_guard_verification on public.drivers;
create trigger trg_drivers_guard_verification
  before update on public.drivers
  for each row execute function public.guard_driver_verification();

drop policy if exists vehicles_select on public.vehicles;
create policy vehicles_select on public.vehicles
  for select using (
    public.is_admin()
    or exists (select 1 from public.drivers d
               where d.id = driver_id and (d.profile_id = auth.uid()
                 or (d.verification_status = 'VERIFIED' and d.active = true)))
  );

drop policy if exists vehicles_write_own on public.vehicles;
create policy vehicles_write_own on public.vehicles
  for all using (exists (select 1 from public.drivers d
                         where d.id = driver_id and d.profile_id = auth.uid())
                 or public.is_admin())
  with check (exists (select 1 from public.drivers d
                      where d.id = driver_id and d.profile_id = auth.uid())
                 or public.is_admin());

drop policy if exists availability_select on public.driver_availability;
create policy availability_select on public.driver_availability
  for select using (
    public.is_admin()
    or exists (select 1 from public.drivers d
               where d.id = driver_id and (d.profile_id = auth.uid()
                 or (d.verification_status = 'VERIFIED' and d.active = true)))
  );

drop policy if exists availability_write_own on public.driver_availability;
create policy availability_write_own on public.driver_availability
  for all using (exists (select 1 from public.drivers d
                         where d.id = driver_id and d.profile_id = auth.uid())
                 or public.is_admin())
  with check (exists (select 1 from public.drivers d
                      where d.id = driver_id and d.profile_id = auth.uid())
                 or public.is_admin());
