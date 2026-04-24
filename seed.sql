-- Cocinero de prueba: María Laura (slug = marialauara)
-- Ejecutar en Supabase Dashboard → SQL Editor
-- Semana actual: lunes 2026-04-21

WITH
  c AS (
    INSERT INTO cocineros (slug, nombre, iniciales, especialidad, bio, zona, telefono, rating, reviews, activo)
    VALUES (
      'marialauara',
      'María Laura',
      'ML',
      'Cocina casera tradicional',
      'Cocinera hace 8 años. Hago la comida que me hubiese gustado recibir cuando trabajaba todo el día. Todo hecho en casa, con ingredientes frescos y amor de verdad.',
      'Palermo · Villa Crespo',
      '5491155555555',
      4.9,
      87,
      true
    ) RETURNING id
  ),
  s AS (
    INSERT INTO semanas (cocinero_id, semana_inicio)
    SELECT id, '2026-04-21'::date FROM c
    RETURNING id
  ),
  pl AS (
    INSERT INTO platos (semana_id, dia, nombre, acompanamiento, precio, icono, orden, activo)
    SELECT s.id, t.dia, t.nombre, t.acompanamiento, t.precio::int, t.icono, t.orden::int, true
    FROM s, (VALUES
      ('Lun', 'Milanesa napolitana',  'Puré de papas casero',        '9500',  '🍖', '1'),
      ('Mar', 'Pollo al limón y ajo', 'Arroz yamani y vegetales',    '8800',  '🍗', '2'),
      ('Mié', 'Tarta de espinaca',    'Ensalada verde con semillas', '7500',  '🥧', '3'),
      ('Jue', 'Guiso de lentejas',    'Pan casero de masa madre',    '7000',  '🥘', '4'),
      ('Vie', 'Cazuela de pollo',     'Papas al horno y morrón',     '8200',  '🍲', '5')
    ) AS t(dia, nombre, acompanamiento, precio, icono, orden)
    RETURNING id
  )
INSERT INTO planes (cocinero_id, nombre, descripcion, precio, ahorro, activo, destacado)
SELECT c.id, t.nombre, t.descripcion, t.precio::int, t.ahorro::int, true, t.destacado::boolean
FROM c, (VALUES
  ('Pack 5 días',  '1 vianda por día, lunes a viernes', '42000',  '5500',  'false'),
  ('Pack 10 días', '2 semanas, 1 vianda/día lun-vie',   '78000',  '12000', 'true'),
  ('Pack mensual', '4 semanas completas, lun a vie',    '148000', '30000', 'false')
) AS t(nombre, descripcion, precio, ahorro, destacado);
