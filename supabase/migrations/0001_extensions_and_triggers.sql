-- MOVA · 0001 · Extensiones, enums y helper de updated_at
-- Mega Prompt §23: cada tabla con UUID, timestamps, FK, constraints, índices y RLS.
-- NOTA: estos ficheros se versionan pero NO se aplican sin credenciales y
-- confirmación de entorno (Límites §3, §5, §6).

create extension if not exists pgcrypto;

-- Roles de usuario (§26)
do $$ begin
  create type public.user_role as enum ('PASSENGER', 'DRIVER', 'ADMIN');
exception when duplicate_object then null; end $$;

-- Verificación de conductores (§38)
do $$ begin
  create type public.verification_status as enum
    ('PENDING', 'VERIFIED', 'REJECTED', 'SUSPENDED');
exception when duplicate_object then null; end $$;

-- Tipos de vehículo (§28)
do $$ begin
  create type public.vehicle_type as enum
    ('TAXI', 'TRICYCLE', 'MOTORCYCLE', 'CAR', 'VAN', 'CARGO', 'OTHER');
exception when duplicate_object then null; end $$;

-- Disponibilidad (§29): es un estado declarado, no GPS
do $$ begin
  create type public.availability_status as enum
    ('AVAILABLE', 'BUSY', 'OFF_DUTY', 'UNAVAILABLE');
exception when duplicate_object then null; end $$;

-- Estados de reserva (§31)
do $$ begin
  create type public.booking_status as enum
    ('PENDING', 'ACCEPTED', 'REJECTED', 'CANCELLED', 'COMPLETED', 'EXPIRED');
exception when duplicate_object then null; end $$;

-- Estados de la cola de sincronización (§15)
do $$ begin
  create type public.sync_status as enum
    ('PENDING', 'PROCESSING', 'SYNCED', 'FAILED', 'CONFLICT');
exception when duplicate_object then null; end $$;

-- Estados de suscripción (§41)
do $$ begin
  create type public.subscription_status as enum
    ('ACTIVE', 'EXPIRED', 'CANCELLED', 'PENDING_PAYMENT');
exception when duplicate_object then null; end $$;

-- updated_at automático
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

-- NOTA: el helper is_admin() se define en 0002, después de crear public.profiles.
-- Una función LANGUAGE sql se valida en el momento de crearse, así que definirla
-- aquí fallaría con "relation public.profiles does not exist".
