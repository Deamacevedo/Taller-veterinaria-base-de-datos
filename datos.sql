-- ===============================================
-- VETERINARIA MI MEJOR AMIGO - DATOS DE PRUEBA (DML)
-- ===============================================

USE veterinaria_mi_mejor_amigo;

-- ===============================================
-- INSERTAR DUEÑOS (5 registros)
-- ===============================================

INSERT INTO duenos (cedula, nombre_completo, telefono, direccion) VALUES
('1234567890', 'María Elena Rodríguez García', '3151234567', 'Calle 15 #23-45, Barrio Centro, Floridablanca'),
('9876543210', 'Carlos Andrés Martínez López', '3209876543', 'Carrera 27 #18-32, Barrio La Cumbre, Bucaramanga'),
('5555666677', 'Ana Sofía Jiménez Herrera', '3125556666', 'Transversal 12 #8-19, Barrio El Poblado, Girón'),
('1111222233', 'Jorge Luis Vargas Moreno', '3181112222', 'Calle 42 #35-67, Barrio San Alonso, Floridablanca'),
('9999888877', 'Lucía Patricia Gómez Silva', '3229998888', 'Avenida González Valencia #145-23, Barrio Provenza, Bucaramanga');

-- ===============================================
-- INSERTAR SERVICIOS (5 registros)
-- ===============================================

INSERT INTO servicios (nombre, descripcion, precio_base) VALUES
('Baño Completo', 'Baño con champú especializado, secado y desenredado del pelaje', 25000.00),
('Consulta Médica', 'Revisión general del estado de salud de la mascota por veterinario', 45000.00),
('Vacunación', 'Aplicación de vacunas preventivas según calendario de vacunación', 35000.00),
('Desparasitación', 'Tratamiento antiparasitario interno y externo', 28000.00),
('Corte de Uñas', 'Corte y limado de uñas para evitar lesiones y mantener higiene', 15000.00);

-- ===============================================
-- INSERTAR MASCOTAS (10 registros)
-- ===============================================

INSERT INTO mascotas (nombre, especie, raza, edad, sexo, vacunada, cedula_dueno, peso) VALUES
('Luna', 'Perro', 'Golden Retriever', 3, 'Hembra', TRUE, '1234567890', 28.50),
('Max', 'Perro', 'Pastor Alemán', 5, 'Macho', TRUE, '1234567890', 35.20),
('Mimi', 'Gato', 'Siamés', 2, 'Hembra', TRUE, '9876543210', 4.80),
('Rocky', 'Perro', 'Bulldog Francés', 4, 'Macho', FALSE, '5555666677', 12.30),
('Pelusa', 'Gato', 'Persa', 6, 'Hembra', TRUE, '5555666677', 5.20),
('Thor', 'Perro', 'Rottweiler', 2, 'Macho', TRUE, '1111222233', 42.10),
('Nala', 'Gato', 'Mestizo', 1, 'Hembra', FALSE, '9999888877', 3.50),
('Buddy', 'Perro', 'Labrador', 7, 'Macho', TRUE, '9876543210', 31.80),
('Coco', 'Ave', 'Canario', 2, 'Macho', FALSE, '1111222233', 0.25),
('Manchas', 'Conejo', 'Holandés', 3, 'Hembra', FALSE, '9999888877', 2.10);

-- ===============================================
-- INSERTAR VISITAS (10 registros)
-- ===============================================

INSERT INTO visitas (id_mascota, id_servicio, fecha_visita, hora_visita, precio_final, observaciones, estado) VALUES
(1, 1, '2025-07-20', '09:30:00', 25000.00, 'Baño completo. Luna se portó muy bien durante el proceso.', 'Completada'),
(2, 2, '2025-07-19', '14:15:00', 45000.00, 'Consulta de rutina. Max presenta excelente estado de salud.', 'Completada'),
(3, 3, '2025-07-18', '10:45:00', 35000.00, 'Aplicación de vacuna antirrábica. Mimi no presentó reacciones.', 'Completada'),
(4, 2, '2025-07-17', '16:20:00', 45000.00, 'Consulta por problema digestivo. Se recetó tratamiento.', 'Completada'),
(5, 1, '2025-07-16', '11:00:00', 25000.00, 'Baño y desenredado de pelaje largo. Pelusa muy colaboradora.', 'Completada'),
(6, 4, '2025-07-15', '13:30:00', 28000.00, 'Desparasitación preventiva. Thor en excelente condición.', 'Completada'),
(7, 5, '2025-07-14', '15:45:00', 15000.00, 'Corte de uñas. Nala un poco nerviosa pero se logró completar.', 'Completada'),
(8, 2, '2025-07-13', '12:00:00', 45000.00, 'Revisión general. Buddy necesita dieta por sobrepeso leve.', 'Completada'),
(9, 2, '2025-07-12', '10:15:00', 45000.00, 'Primera consulta de Coco. Ave en buen estado general.', 'Completada'),
(10, 3, '2025-07-11', '14:30:00', 35000.00, 'Primera vacunación de Manchas. Conejo muy tranquilo.', 'Completada');

-- ===============================================
-- INSERTAR TRATAMIENTOS (5 registros)
-- ===============================================

INSERT INTO tratamientos (nombre, observaciones, id_visita, duracion_dias, frecuencia, dosis, fecha_inicio, fecha_fin) VALUES
(
    'Antibiótico Amoxicilina', 
    'Tratamiento para infección gastrointestinal leve en Rocky. Administrar con comida para evitar molestias estomacales.',
    4, 
    7, 
    'Cada 12 horas', 
    '250mg por dosis', 
    '2025-07-17', 
    '2025-07-24'
),
(
    'Dieta Controlada Hills', 
    'Plan nutricional para reducción de peso en Buddy. Eliminar premios entre comidas y ejercicio diario.',
    8, 
    30, 
    'Diaria', 
    '200g divididos en 2 comidas', 
    '2025-07-13', 
    '2025-08-12'
),
(
    'Suplemento Vitamínico', 
    'Complejo vitamínico para fortalecer sistema inmune de Nala después del estrés del corte de uñas.',
    7, 
    15, 
    'Una vez al día', 
    '1 tableta', 
    '2025-07-14', 
    '2025-07-29'
),
(
    'Antialérgico Cetirizina', 
    'Tratamiento preventivo post-vacunación para Mimi. Controlar posibles reacciones alérgicas.',
    3, 
    3, 
    'Cada 24 horas', 
    '5mg', 
    '2025-07-18', 
    '2025-07-21'
),
(
    'Probióticos', 
    'Restaurar flora intestinal de Thor después de la desparasitación. Mejorar digestión.',
    6, 
    10, 
    'Con cada comida', 
    '1 sobre', 
    '2025-07-15', 
    '2025-07-25'
);

-- ===============================================
-- DATOS ADICIONALES PARA MAYOR REALISMO
-- ===============================================

-- Agregar más visitas para demostrar el historial
INSERT INTO visitas (id_mascota, id_servicio, fecha_visita, hora_visita, precio_final, observaciones, estado) VALUES
(1, 3, '2025-06-15', '11:30:00', 35000.00, 'Vacunación anual de Luna. Sin complicaciones.', 'Completada'),
(2, 1, '2025-06-10', '16:00:00', 25000.00, 'Baño mensual de Max. Pelaje en excelentes condiciones.', 'Completada'),
(3, 5, '2025-05-20', '14:20:00', 15000.00, 'Corte de uñas regular para Mimi.', 'Completada'),
(4, 4, '2025-05-15', '09:45:00', 28000.00, 'Desparasitación semestral de Rocky.', 'Completada'),
(5, 2, '2025-04-25', '15:15:00', 45000.00, 'Chequeo médico de Pelusa. Todo normal.', 'Completada');

-- Agregar tratamientos para las visitas adicionales
INSERT INTO tratamientos (nombre, observaciones, id_visita, duracion_dias, frecuencia, dosis, fecha_inicio, fecha_fin) VALUES
(
    'Champú Medicado', 
    'Tratamiento dermatológico preventivo para Max después del baño. Mantener pelaje saludable.',
    12, 
    14, 
    'Cada 3 días', 
    'Aplicación tópica', 
    '2025-06-10', 
    '2025-06-24'
),
(
    'Pasta Dental Canina', 
    'Higiene dental para Rocky después de la desparasitación. Prevenir problemas bucales.',
    14, 
    21, 
    'Diaria', 
    'Cepillado nocturno', 
    '2025-05-15', 
    '2025-06-05'
);

-- ===============================================
-- VERIFICACIÓN DE DATOS INSERTADOS
-- ===============================================

-- Contar registros por tabla
SELECT 'DUEÑOS' as Tabla, COUNT(*) as Total FROM duenos
UNION ALL
SELECT 'SERVICIOS', COUNT(*) FROM servicios  
UNION ALL
SELECT 'MASCOTAS', COUNT(*) FROM mascotas
UNION ALL  
SELECT 'VISITAS', COUNT(*) FROM visitas
UNION ALL
SELECT 'TRATAMIENTOS', COUNT(*) FROM tratamientos;

