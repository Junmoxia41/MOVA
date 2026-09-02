-- MOVA · 0005 · bookings (§31, §32)

create table if not exists public.bookings (
  id                uuid primary key default gen_random_uuid(),
  passenger_id      uuid not null references public.profiles (id) on delete cascade,
  driver_id         uuid not null references public.drivers (id) on delete restrict,
  vehicle_id        uuid references public.vehicles (id) on delete set null,
  -- V1 usa zonas y direcciones escritas, no coordenadas (§79)
  pickup_area       text not null,
  destination_area  text not null,
  requested_date    date not null,
  requested_time    time not null,
  passenger_count   smallint not null default 1 check (passenger_count between 1 and 60),
  notes             text,
  status            public.booking_status not null default 'PENDING',
  -- Base para la resolución de conflictos (§18)
  version           integer not null default 1,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now(),
  constraint bookings_pickup_len check (char_length(pickup_area) between 1 and 200),
  constraint bookings_destination_len check (char_length(destination_area) between 1 and 200),
  constraint bookings_notes_len check (notes is null or char_length(notes) <= 500)
);

comment on table public.bookings is 'Reservas. Sin coordenadas en V1 (§79).';

create index if not exists ix_bookings_passenger on public.bookings (passenger_id, created_at desc);
create index if not exists ix_bookings_driver on public.bookings (driver_id, requested_date);
create index if not exists ix_bookings_status on public.bookings (status);
-- Evita solapamientos obvios: un conductor, un día y una hora, una reserva no cancelada
create unique index if not exists ux_bookings_driver_slot
  on public.bookings (driver_id, requested_date, requested_time)
  where status in ('PENDING', 'ACCEPTED');

create trigger trg_bookings_updated_at
  before update on public.bookings
  for each row execute function public.set_updated_at();

-- Transiciones de estado permitidas (§31, §32)
create or replace function public.guard_booking_transition()
returns trigger
language plpgsql
as $$
declare
  v_driver_owner boolean;
begin
  if new.status = old.status then
    return new;
  end if;

  select d.profile_id = auth.uid() into v_driver_owner
    from public.drivers d where d.id = new.driver_id;

  case old.status
    when 'PENDING' then
      if new.status not in ('ACCEPTED', 'REJECTED', 'CANCELLED', 'EXPIRED') then
        raise exception 'transición no permitida desde PENDING';
      end if;
      -- Aceptar/rechazar es del conductor; cancelar, del pasajero
      if new.status in ('ACCEPTED', 'REJECTED') and not coalesce(v_driver_owner, false)
         and not public.is_admin() then
        raise exception 'solo el conductor acepta o rechaza';
      end if;
      if new.status = 'CANCELLED'
         and new.passenger_id <> auth.uid()
         and not coalesce(v_driver_owner, false)
         and not public.is_admin() then
        raise exception 'no autorizado a cancelar esta reserva';
      end if;
    when 'ACCEPTED' then
      if new.status not in ('CANCELLED', 'COMPLETED') then
        raise exception 'transición no permitida desde ACCEPTED';
      end if;
    when 'COMPLETED' then
      raise exception 'una reserva completada no cambia de estado';
    else
      raise exception 'estado final: no se admiten más cambios';
  end case;

  new.version := old.version + 1;
  return new;
end;
$$;

drop trigger if exists trg_bookings_transition on public.bookings;
create trigger trg_bookings_transition
  before update on public.bookings
  for each row execute function public.guard_booking_transition();

-- RLS (§24): el pasajero ve las suyas; el conductor, las que le asignaron.
alter table public.bookings enable row level security;

drop policy if exists bookings_select on public.bookings;
create policy bookings_select on public.bookings
  for select using (
    passenger_id = auth.uid()
    or exists (select 1 from public.drivers d
               where d.id = driver_id and d.profile_id = auth.uid())
    or public.is_admin()
  );

drop policy if exists bookings_insert_own on public.bookings;
create policy bookings_insert_own on public.bookings
  for insert with check (passenger_id = auth.uid());

drop policy if exists bookings_update_party on public.bookings;
create policy bookings_update_party on public.bookings
  for update using (
    passenger_id = auth.uid()
    or exists (select 1 from public.drivers d
               where d.id = driver_id and d.profile_id = auth.uid())
    or public.is_admin()
  ) with check (
    passenger_id = auth.uid()
    or exists (select 1 from public.drivers d
               where d.id = driver_id and d.profile_id = auth.uid())
    or public.is_admin()
  );

-- Sin borrado por API: las reservas son historial (§75). Solo admin.
drop policy if exists bookings_delete_admin on public.bookings;
create policy bookings_delete_admin on public.bookings
  for delete using (public.is_admin());
