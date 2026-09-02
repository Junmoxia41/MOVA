-- MOVA · Seed de DESARROLLO (Límites §5: seeds solo en desarrollo).
-- NUNCA ejecutar contra producción o contra una base cuyo entorno no esté confirmado (§6).
-- Los precios son PLACEHOLDER: el precio real es decisión del propietario (Límites §8).

-- Zonas de Santa Clara (§78, §79)
insert into public.service_areas (name, municipality, province, reference_points) values
  ('Centro',      'Santa Clara', 'Villa Clara', 'Parque Vidal, Catedral, Boulevard'),
  ('Hospital',    'Santa Clara', 'Villa Clara', 'Hospital Arnaldo Milián Castro'),
  ('Universidad', 'Santa Clara', 'Villa Clara', 'UCLV, Facultad de Mecánica'),
  ('Reparto',     'Santa Clara', 'Villa Clara', 'Reparto Escambray'),
  ('Capiro',      'Santa Clara', 'Villa Clara', 'Loma del Capiro'),
  ('Vigía',       'Santa Clara', 'Villa Clara', 'Reparto Vigía'),
  ('Sakena',      'Santa Clara', 'Villa Clara', 'Reparto Sakena'),
  ('Terminal',    'Santa Clara', 'Villa Clara', 'Terminal de Ómnibus, Tren')
on conflict (lower(name), lower(municipality)) do nothing;

-- Planes (§39): precio 0 = placeholder pendiente de decisión del propietario
insert into public.driver_plans (name, price, currency, duration_days, featured, active,
                                 features, ranking_weight, sort_order) values
  ('FREE',    0, 'CUP', 30, false, true, '["Perfil público","Recibir reservas"]'::jsonb, 1.0, 1),
  ('PRO',     0, 'CUP', 30, true,  true, '["Todo lo de FREE","Mayor visibilidad"]'::jsonb, 1.5, 2),
  ('PREMIUM', 0, 'CUP', 30, true,  true, '["Todo lo de PRO","Máxima visibilidad"]'::jsonb, 2.0, 3)
on conflict (name) do nothing;

-- app_config (§58)
insert into public.app_config (key, value, description) values
  ('latest_version',             '"1.0.0"'::jsonb, 'Última versión nativa disponible (§62)'),
  ('minimum_supported_version',  '"1.0.0"'::jsonb, 'Por debajo: avisar de actualización (§62)'),
  ('maintenance_mode',           'false'::jsonb,   'Aviso de mantenimiento'),
  ('welcome_message',            '"Tu ciudad. Tu ruta. Tu movimiento."'::jsonb, 'Mensaje de portada')
on conflict (key) do update
  set value = excluded.value, updated_at = now();
