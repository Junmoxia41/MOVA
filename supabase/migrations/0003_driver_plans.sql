-- MOVA · 0003 · driver_plans
-- §39: FREE / PRO / PREMIUM. Los precios NO se hardcodean en la app: viven aquí.
-- Los valores concretos de precio y moneda son DECISIÓN DEL PROPIETARIO (Límites §8).
-- El seed los crea con precio 0 y currency 'CUP' como placeholder explícito.

create table if not exists public.driver_plans (
  id             uuid primary key default gen_random_uuid(),
  name           text not null unique,
  price          numeric(12, 2) not null default 0 check (price >= 0),
  currency       text not null default 'CUP',
  duration_days  integer not null default 30 check (duration_days > 0),
  featured       boolean not null default false,
  active         boolean not null default true,
  features       jsonb not null default '[]'::jsonb,
  -- Peso relativo para el ranking: el dinero no es el único factor (§35, §80)
  ranking_weight numeric(5, 2) not null default 1.0 check (ranking_weight >= 0),
  sort_order     integer not null default 0,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now()
);

comment on table public.driver_plans is
  'Planes de conductor. Precios y moneda: decisión del propietario (Límites §8).';

create trigger trg_driver_plans_updated_at
  before update on public.driver_plans
  for each row execute function public.set_updated_at();

alter table public.driver_plans enable row level security;

drop policy if exists driver_plans_select on public.driver_plans;
create policy driver_plans_select on public.driver_plans
  for select using (active = true or public.is_admin());

drop policy if exists driver_plans_write_admin on public.driver_plans;
create policy driver_plans_write_admin on public.driver_plans
  for all using (public.is_admin()) with check (public.is_admin());
