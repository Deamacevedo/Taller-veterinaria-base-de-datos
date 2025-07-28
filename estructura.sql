-- ===============================================
-- VETERINARIA MI MEJOR AMIGO - ESTRUCTURA DDL
-- ===============================================

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS veterinaria_mi_mejor_amigo;
USE veterinaria_mi_mejor_amigo;

-- ===============================================
-- TABLA: DUEÑOS
-- ===============================================
CREATE TABLE duenos (
    cedula VARCHAR(20) PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    direccion TEXT NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================================
-- TABLA: SERVICIOS
-- ===============================================
CREATE TABLE servicios (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT NOT NULL,
    precio_base DECIMAL(10,2) NOT NULL CHECK (precio_base > 0),
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================================
-- TABLA: MASCOTAS
-- ===============================================
CREATE TABLE mascotas (
    id_mascota INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    especie ENUM('Perro', 'Gato', 'Ave', 'Conejo', 'Hamster', 'Reptil', 'Otro') NOT NULL,
    raza VARCHAR(50) NOT NULL,
    edad INT NOT NULL CHECK (edad >= 0 AND edad <= 30),
    sexo ENUM('Macho', 'Hembra') NOT NULL,
    vacunada BOOLEAN DEFAULT FALSE,
    cedula_dueno VARCHAR(20) NOT NULL,
    peso DECIMAL(5,2) DEFAULT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cedula_dueno) REFERENCES duenos(cedula) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ===============================================
-- TABLA: VISITAS
-- ===============================================
CREATE TABLE visitas (
    id_visita INT AUTO_INCREMENT PRIMARY KEY,
    id_mascota INT NOT NULL,
    id_servicio INT NOT NULL,
    fecha_visita DATE NOT NULL,
    hora_visita TIME DEFAULT NULL,
    precio_final DECIMAL(10,2) DEFAULT NULL,
    observaciones TEXT DEFAULT NULL,
    estado ENUM('Completada', 'Pendiente', 'Cancelada') DEFAULT 'Completada',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_mascota) REFERENCES mascotas(id_mascota) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_servicio) REFERENCES servicios(id_servicio) 
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ===============================================
-- TABLA: TRATAMIENTOS
-- ===============================================
CREATE TABLE tratamientos (
    id_tratamiento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    observaciones TEXT NOT NULL,
    id_visita INT NOT NULL,
    duracion_dias INT DEFAULT NULL CHECK (duracion_dias > 0),
    frecuencia VARCHAR(50) DEFAULT NULL,
    dosis VARCHAR(100) DEFAULT NULL,
    fecha_inicio DATE DEFAULT NULL,
    fecha_fin DATE DEFAULT NULL,
    activo BOOLEAN DEFAULT TRUE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_visita) REFERENCES visitas(id_visita) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ===============================================
-- ÍNDICES PARA OPTIMIZAR CONSULTAS
-- ===============================================

-- Índices en campos de búsqueda frecuente
CREATE INDEX idx_mascota_nombre ON mascotas(nombre);
CREATE INDEX idx_mascota_especie ON mascotas(especie);
CREATE INDEX idx_visita_fecha ON visitas(fecha_visita);
CREATE INDEX idx_dueno_nombre ON duenos(nombre_completo);
CREATE INDEX idx_servicio_nombre ON servicios(nombre);

-- Índices compuestos para consultas específicas
CREATE INDEX idx_mascota_dueno_especie ON mascotas(cedula_dueno, especie);
CREATE INDEX idx_visita_mascota_fecha ON visitas(id_mascota, fecha_visita);
CREATE INDEX idx_tratamiento_visita_activo ON tratamientos(id_visita, activo);

-- ===============================================
-- VISTAS ÚTILES PARA CONSULTAS FRECUENTES
-- ===============================================

-- Vista: Información completa de mascotas con sus dueños
CREATE VIEW vista_mascotas_completa AS
SELECT 
    m.id_mascota,
    m.nombre AS nombre_mascota,
    m.especie,
    m.raza,
    m.edad,
    m.sexo,
    m.vacunada,
    m.peso,
    d.cedula,
    d.nombre_completo AS nombre_dueno,
    d.telefono,
    d.direccion
FROM mascotas m
INNER JOIN duenos d ON m.cedula_dueno = d.cedula;

-- Vista: Historial de visitas con detalles
CREATE VIEW vista_historial_visitas AS
SELECT 
    v.id_visita,
    v.fecha_visita,
    v.hora_visita,
    v.precio_final,
    v.estado,
    m.nombre AS nombre_mascota,
    m.especie,
    d.nombre_completo AS nombre_dueno,
    d.telefono,
    s.nombre AS servicio,
    s.descripcion AS descripcion_servicio
FROM visitas v
INNER JOIN mascotas m ON v.id_mascota = m.id_mascota
INNER JOIN duenos d ON m.cedula_dueno = d.cedula
INNER JOIN servicios s ON v.id_servicio = s.id_servicio;

-- Vista: Tratamientos activos
CREATE VIEW vista_tratamientos_activos AS
SELECT 
    t.id_tratamiento,
    t.nombre AS tratamiento,
    t.observaciones,
    t.duracion_dias,
    t.frecuencia,
    t.dosis,
    t.fecha_inicio,
    t.fecha_fin,
    v.fecha_visita,
    m.nombre AS nombre_mascota,
    d.nombre_completo AS nombre_dueno,
    d.telefono
FROM tratamientos t
INNER JOIN visitas v ON t.id_visita = v.id_visita
INNER JOIN mascotas m ON v.id_mascota = m.id_mascota
INNER JOIN duenos d ON m.cedula_dueno = d.cedula
WHERE t.activo = TRUE;

-- ===============================================
-- PROCEDIMIENTOS ALMACENADOS ÚTILES
-- ===============================================

DELIMITER //

-- Procedimiento para registrar una visita completa
CREATE PROCEDURE RegistrarVisita(
    IN p_id_mascota INT,
    IN p_id_servicio INT,
    IN p_fecha_visita DATE,
    IN p_hora_visita TIME,
    IN p_observaciones TEXT,
    OUT p_id_visita INT
)
BEGIN
    DECLARE v_precio_base DECIMAL(10,2);
    
    -- Obtener precio base del servicio
    SELECT precio_base INTO v_precio_base 
    FROM servicios 
    WHERE id_servicio = p_id_servicio;
    
    -- Insertar la visita
    INSERT INTO visitas (id_mascota, id_servicio, fecha_visita, hora_visita, precio_final, observaciones)
    VALUES (p_id_mascota, p_id_servicio, p_fecha_visita, p_hora_visita, v_precio_base, p_observaciones);
    
    SET p_id_visita = LAST_INSERT_ID();
END //

DELIMITER ;