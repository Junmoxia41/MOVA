-- MOVA · 0006 · reviews y favorites (§36, §37)

create table if not exists public.reviews (
  id           uuid primary key default gen_random_uuid(),
  booking_id   uuid not null unique references public.bookings (id) on delete cascade,
  driver_id    uuid not null references public.drivers (id) on delete cascade,
  author_id    uuid not null references public.profiles (id) on delete cascade,
  rating       smallint not null check (rating between 1 and 5),
  punctuality  smallint check (punctuality between 1 and 5),
  treatment    smallint check (treatment between 1 and 5),
  vehicle      smallint check (vehicle between 1 and 5),
  comment      text,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  constraint reviews_comment_len check (comment is null or char_length(comment) <= 1000)
);

comment on table public.reviews is
  'Una reseña por reserva completada. booking_id UNIQUE impide reseñas infinitas (§37).';

create index if not exists ix_reviews_driver on public.reviews (driver_id, created_at desc);

create trigger trg_reviews_updated_at
  before update on public.reviews
  for each row execute function public.set_updated_at();

-- Solo se puede reseñar una reserva COMPLETED y propia (§37)
create or replace function public.guard_review_insert()
returns trigger
language plpgsql
as $$
declare
  v_booking public.bookings;
begin
  select * into v_booking from public.bookings b where b.id = new.booking_id;

  if v_booking.id is null then
    raise exception 'reserva inexistente';
  end if;
  if v_booking.status <> 'COMPLETED' then
    raise exception 'solo se puede reseñar una reserva completada';
  end if;
  if v_booking.passenger_id <> new.author_id then
    raise exception 'solo el pasajero de la reserva puede reseñarla';
  end if;
  if v_booking.driver_id <> new.driver_id then
    raise exception 'el conductor reseñado no coincide con la reserva';
  end if;
  return new;
end;
$$;

drop trigger if exists trg_reviews_guard_insert on public.reviews;
create trigger trg_reviews_guard_insert
  before insert on public.reviews
  for each row execute function public.guard_review_insert();

-- Favoritos: Room responde al instante; Supabase sincroniza cuando toca (§36)
create table if not exists public.favorites (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references public.profiles (id) on delete cascade,
  driver_id   uuid not null references public.drivers (id) on delete cascade,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  constraint favorites_unique unique (user_id, driver_id)
);

create index if not exists ix_favorites_user on public.favorites (user_id);

create trigger trg_favorites_updated_at
  before update on public.favorites
  for each row execute function public.set_updated_at();

alter table public.reviews enable row level security;
alter table public.favorites enable row level security;

drop policy if exists reviews_select on public.reviews;
create policy reviews_select on public.reviews
  for select using (true);  -- reseñas de conductores verificados: públicas (§97)

drop policy if exists reviews_insert_own on public.reviews;
create policy reviews_insert_own on public.reviews
  for insert with check (author_id = auth.uid());

drop policy if exists reviews_delete_admin on public.reviews;
create policy reviews_delete_admin on public.reviews
  for delete using (public.is_admin());

-- Favoritos: estrictamente privados (§24)
drop policy if exists favorites_own on public.favorites;
create policy favorites_own on public.favorites
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());
