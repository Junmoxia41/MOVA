-- MOVA · 0002 · profiles y service_areas

create table if not exists public.profiles (
  id          uuid primary key references auth.users (id) on delete cascade,
  full_name   text,
  phone       text,
  photo_url   text,
  role        public.user_role not null default 'PASSENGER',
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  constraint profiles_full_name_len check (full_name is null or char_length(full_name) <= 120)
);

comment on table public.profiles is 'Perfil de usuario. id = auth.users.id (§27).';

create trigger trg_profiles_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

-- Helper reutilizable: ¿el usuario autenticado es ADMIN?
-- Se define aquí (y no en 0001) porque una función LANGUAGE sql se valida al crearse
-- y necesita que public.profiles ya exista.
create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.profiles p
    where p.id = auth.uid() and p.role = 'ADMIN'
  );
$$;

-- Zonas geográficas: V1 usa zonas y referencias, no GPS (§78, §79)
create table if not exists public.service_areas (
  id                uuid primary key default gen_random_uuid(),
  name              text not null,
  municipality      text not null default 'Santa Clara',
  province          text not null default 'Villa Clara',
  reference_points  text,
  active            boolean not null default true,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now(),
  constraint service_areas_name_len check (char_length(name) between 1 and 120)
);

create unique index if not exists ux_service_areas_name
  on public.service_areas (lower(name), lower(municipality));

create trigger trg_service_areas_updated_at
  before update on public.service_areas
  for each row execute function public.set_updated_at();

-- RLS (§24)
alter table public.profiles enable row level security;
alter table public.service_areas enable row level security;

drop policy if exists profiles_select on public.profiles;
create policy profiles_select on public.profiles
  for select using (id = auth.uid() or public.is_admin());

drop policy if exists profiles_insert_own on public.profiles;
create policy profiles_insert_own on public.profiles
  for insert with check (id = auth.uid());

-- Un usuario modifica su propio perfil; nunca el de otro (§24). El rol no es editable por él.
drop policy if exists profiles_update_own on public.profiles;
create policy profiles_update_own on public.profiles
  for update using (id = auth.uid() or public.is_admin())
  with check (id = auth.uid() or public.is_admin());

drop policy if exists profiles_delete_admin on public.profiles;
create policy profiles_delete_admin on public.profiles
  for delete using (public.is_admin());

-- Las zonas son catálogo público (§97: PUBLIC)
drop policy if exists service_areas_select on public.service_areas;
create policy service_areas_select on public.service_areas
  for select using (active = true or public.is_admin());

drop policy if exists service_areas_write_admin on public.service_areas;
create policy service_areas_write_admin on public.service_areas
  for all using (public.is_admin()) with check (public.is_admin());
