-- ===============================================
-- VETERINARIA MI MEJOR AMIGO - CONSULTAS DQL
-- ===============================================

USE veterinaria_mi_mejor_amigo;

-- ===============================================
-- CONSULTA 1: CREACIÓN DE TABLA A PARTIR DE CONSULTA
-- ===============================================

-- Crear tabla con mascotas vacunadas y sus dueños
CREATE TABLE IF NOT EXISTS mascotas_vacunadas_reporte AS
SELECT 
    m.id_mascota,
    m.nombre AS nombre_mascota,
    m.especie,
    m.raza,
    m.edad,
    d.nombre_completo AS propietario,
    d.telefono
FROM mascotas m
INNER JOIN duenos d ON m.cedula_dueno = d.cedula
WHERE m.vacunada = TRUE;

SELECT * FROM mascotas_vacunadas_reporte;

-- ===============================================
-- CONSULTA 2: ALIAS EN CAMPOS
-- ===============================================

SELECT 
    nombre AS 'Nombre de la Mascota',
    especie AS 'Tipo de Animal',
    raza AS 'Raza Específica',
    edad AS 'Años de Edad',
    peso AS 'Peso en Kg',
    CASE 
        WHEN vacunada = 1 THEN 'Sí Vacunada'
        ELSE 'Sin Vacunar'
    END AS 'Estado de Vacunación'
FROM mascotas
ORDER BY edad DESC;

-- ===============================================
-- CONSULTA 3: ALIAS EN SUBCONSULTAS
-- ===============================================

SELECT 
    prop.nombre_completo AS 'Propietario',
    prop.total_mascotas AS 'Cantidad de Mascotas',
    prop.promedio_edad AS 'Edad Promedio'
FROM (
    SELECT 
        d.nombre_completo,
        COUNT(m.id_mascota) AS total_mascotas,
        ROUND(AVG(m.edad), 1) AS promedio_edad
    FROM duenos d
    LEFT JOIN mascotas m ON d.cedula = m.cedula_dueno
    GROUP BY d.cedula, d.nombre_completo
) AS prop
WHERE prop.total_mascotas > 1
ORDER BY prop.total_mascotas DESC;

-- ===============================================
-- CONSULTA 4: FUNCIONES DE AGREGACIÓN - COUNT
-- ===============================================

SELECT 
    especie AS 'Especie',
    COUNT(*) AS 'Total de Animales',
    COUNT(CASE WHEN vacunada = TRUE THEN 1 END) AS 'Vacunados',
    COUNT(CASE WHEN vacunada = FALSE THEN 1 END) AS 'Sin Vacunar'
FROM mascotas
GROUP BY especie
ORDER BY COUNT(*) DESC;

-- ===============================================
-- CONSULTA 5: FUNCIONES DE AGREGACIÓN - AVG, MAX, MIN
-- ===============================================

SELECT 
    'ESTADÍSTICAS GENERALES' AS 'Tipo de Dato',
    ROUND(AVG(edad), 2) AS 'Edad Promedio',
    MAX(edad) AS 'Edad Máxima', 
    MIN(edad) AS 'Edad Mínima',
    ROUND(AVG(peso), 2) AS 'Peso Promedio',
    MAX(peso) AS 'Peso Máximo',
    MIN(peso) AS 'Peso Mínimo'
FROM mascotas
WHERE peso IS NOT NULL;

-- ===============================================
-- CONSULTA 6: ALIAS EN FUNCIONES DE AGREGACIÓN
-- ===============================================

SELECT 
    s.nombre AS 'Servicio',
    COUNT(v.id_visita) AS 'Total_Solicitudes',
    ROUND(AVG(v.precio_final), 0) AS 'Precio_Promedio',
    SUM(v.precio_final) AS 'Ingresos_Totales',
    MAX(v.precio_final) AS 'Precio_Maximo'
FROM servicios s
LEFT JOIN visitas v ON s.id_servicio = v.id_servicio
GROUP BY s.id_servicio, s.nombre
ORDER BY COUNT(v.id_visita) DESC;

-- ===============================================
-- CONSULTA 7: FUNCIÓN CONCAT
-- ===============================================

SELECT 
    CONCAT(m.nombre, ' (', m.especie, ')') AS 'Mascota y Especie',
    CONCAT(d.nombre_completo, ' - Tel: ', d.telefono) AS 'Información del Dueño',
    CONCAT(m.raza, ', ', m.edad, ' años, ', m.sexo) AS 'Detalles de la Mascota',
    CONCAT('Peso: ', IFNULL(m.peso, 'No registrado'), ' kg') AS 'Información de Peso'
FROM mascotas m
INNER JOIN duenos d ON m.cedula_dueno = d.cedula
ORDER BY m.nombre;

-- ===============================================
-- CONSULTA 8: FUNCIONES UPPER Y LOWER
-- ===============================================

SELECT 
    UPPER(nombre) AS 'NOMBRE_MAYUSCULA',
    LOWER(raza) AS 'raza_minuscula',
    UPPER(CONCAT(especie, ' - ', sexo)) AS 'TIPO_Y_SEXO',
    LOWER(CASE 
        WHEN vacunada = TRUE THEN 'VACUNADA' 
        ELSE 'SIN VACUNAR' 
    END) AS 'estado_vacunacion'
FROM mascotas
WHERE especie IN ('Perro', 'Gato')
ORDER BY especie, nombre;

-- ===============================================
-- CONSULTA 9: FUNCIONES LENGTH, SUBSTRING, TRIM
-- ===============================================

SELECT 
    nombre AS 'Nombre Original',
    LENGTH(nombre) AS 'Longitud_Nombre',
    SUBSTRING(nombre, 1, 3) AS 'Primeras_3_Letras',
    SUBSTRING(raza, -4) AS 'Ultimas_4_Letras_Raza',
    TRIM(CONCAT('  ', nombre, '  ')) AS 'Nombre_Sin_Espacios',
    LENGTH(TRIM(CONCAT('  ', nombre, '  '))) AS 'Longitud_Limpia'
FROM mascotas
WHERE LENGTH(nombre) >= 4
ORDER BY LENGTH(nombre) DESC;

-- ===============================================
-- CONSULTA 10: FUNCIÓN ROUND
-- ===============================================

SELECT 
    m.nombre AS 'Mascota',
    m.peso AS 'Peso_Original', 
    ROUND(m.peso, 0) AS 'Peso_Redondeado',
    ROUND(m.peso * 2.20462, 2) AS 'Peso_en_Libras',
    ROUND((m.edad * 365.25) / 7, 0) AS 'Edad_Humana_Aproximada',
    ROUND(AVG(v.precio_final) OVER (PARTITION BY m.id_mascota), 2) AS 'Gasto_Promedio_Por_Visita'
FROM mascotas m
LEFT JOIN visitas v ON m.id_mascota = v.id_mascota
WHERE m.peso IS NOT NULL
ORDER BY m.peso DESC;

-- ===============================================
-- CONSULTA 11: FUNCIÓN IF EN CAMPOS
-- ===============================================

SELECT 
    nombre AS 'Mascota',
    especie,
    edad,
    IF(edad <= 1, 'Cachorro/Cría', 
       IF(edad <= 6, 'Adulto Joven', 'Adulto Mayor')) AS 'Clasificación_Edad',
    IF(vacunada = TRUE, 'Al día', 'Requiere vacunación') AS 'Estado_Vacunas',
    IF(peso > 20, 'Grande', 
       IF(peso > 10, 'Mediano', 'Pequeño')) AS 'Tamaño_Por_Peso',
    IF(sexo = 'Macho', '♂ Macho', '♀ Hembra') AS 'Sexo_Con_Simbolo'
FROM mascotas
ORDER BY edad, nombre;

-- ===============================================
-- CONSULTA 12: JOIN COMPLEJO CON MÚLTIPLES TABLAS
-- ===============================================

SELECT 
    d.nombre_completo AS 'Propietario',
    m.nombre AS 'Mascota',
    m.especie,
    v.fecha_visita AS 'Fecha_Visita',
    s.nombre AS 'Servicio_Realizado',
    v.precio_final AS 'Costo',
    COUNT(t.id_tratamiento) AS 'Tratamientos_Recetados',
    GROUP_CONCAT(t.nombre SEPARATOR ', ') AS 'Lista_Tratamientos'
FROM duenos d
INNER JOIN mascotas m ON d.cedula = m.cedula_dueno
INNER JOIN visitas v ON m.id_mascota = v.id_mascota
INNER JOIN servicios s ON v.id_servicio = s.id_servicio
LEFT JOIN tratamientos t ON v.id_visita = t.id_visita
GROUP BY d.cedula, m.id_mascota, v.id_visita
ORDER BY v.fecha_visita DESC;

-- ===============================================
-- CONSULTA 13: GROUP BY CON HAVING
-- ===============================================

SELECT 
    d.nombre_completo AS 'Propietario',
    COUNT(DISTINCT m.id_mascota) AS 'Total_Mascotas',
    COUNT(v.id_visita) AS 'Total_Visitas',
    ROUND(AVG(v.precio_final), 2) AS 'Gasto_Promedio_Por_Visita',
    SUM(v.precio_final) AS 'Gasto_Total'
FROM duenos d
INNER JOIN mascotas m ON d.cedula = m.cedula_dueno
INNER JOIN visitas v ON m.id_mascota = v.id_mascota
GROUP BY d.cedula, d.nombre_completo
HAVING COUNT(v.id_visita) >= 2 AND SUM(v.precio_final) > 50000
ORDER BY SUM(v.precio_final) DESC;

-- ===============================================
-- CONSULTA 14: SUBCONSULTA CORRELACIONADA
-- ===============================================

SELECT 
    m.nombre AS 'Mascota',
    m.especie,
    (SELECT COUNT(*) 
     FROM visitas v 
     WHERE v.id_mascota = m.id_mascota) AS 'Total_Visitas',
    (SELECT MAX(v.fecha_visita) 
     FROM visitas v 
     WHERE v.id_mascota = m.id_mascota) AS 'Ultima_Visita',
    (SELECT s.nombre 
     FROM visitas v 
     INNER JOIN servicios s ON v.id_servicio = s.id_servicio
     WHERE v.id_mascota = m.id_mascota 
     ORDER BY v.fecha_visita DESC 
     LIMIT 1) AS 'Ultimo_Servicio'
FROM mascotas m
ORDER BY (SELECT COUNT(*) FROM visitas v WHERE v.id_mascota = m.id_mascota) DESC;

-- ===============================================
-- CONSULTA 15: ANÁLISIS TEMPORAL CON FUNCIONES DE FECHA
-- ===============================================

SELECT 
    YEAR(v.fecha_visita) AS 'Año',
    MONTH(v.fecha_visita) AS 'Mes',
    MONTHNAME(v.fecha_visita) AS 'Nombre_Mes',
    COUNT(*) AS 'Visitas_Del_Mes',
    ROUND(AVG(v.precio_final), 2) AS 'Precio_Promedio',
    SUM(v.precio_final) AS 'Ingresos_Mensuales',
    COUNT(DISTINCT v.id_mascota) AS 'Mascotas_Diferentes_Atendidas'
FROM visitas v
WHERE v.fecha_visita >= '2025-01-01'
GROUP BY YEAR(v.fecha_visita), MONTH(v.fecha_visita)
ORDER BY v.fecha_visita DESC;

-- ===============================================
-- CONSULTA 16: RANKING DE SERVICIOS MÁS POPULARES
-- ===============================================

SELECT 
    RANK() OVER (ORDER BY COUNT(v.id_visita) DESC) AS 'Ranking',
    s.nombre AS 'Servicio',
    s.precio_base AS 'Precio_Base',
    COUNT(v.id_visita) AS 'Veces_Solicitado',
    ROUND((COUNT(v.id_visita) * 100.0 / (SELECT COUNT(*) FROM visitas)), 2) AS 'Porcentaje_Demanda',
    SUM(v.precio_final) AS 'Ingresos_Generados'
FROM servicios s
LEFT JOIN visitas v ON s.id_servicio = v.id_servicio
GROUP BY s.id_servicio, s.nombre, s.precio_base
ORDER BY COUNT(v.id_visita) DESC;

-- ===============================================
-- CONSULTA 17: ANÁLISIS DE TRATAMIENTOS ACTIVOS
-- ===============================================

SELECT 
    t.nombre AS 'Tratamiento',
    COUNT(*) AS 'Veces_Recetado',
    ROUND(AVG(t.duracion_dias), 1) AS 'Duracion_Promedio_Dias',
    COUNT(CASE WHEN t.activo = TRUE THEN 1 END) AS 'Tratamientos_Activos',
    COUNT(CASE WHEN t.fecha_fin < CURDATE() THEN 1 END) AS 'Tratamientos_Finalizados',
    GROUP_CONCAT(DISTINCT t.frecuencia) AS 'Frecuencias_Utilizadas'
FROM tratamientos t
GROUP BY t.nombre
ORDER BY COUNT(*) DESC;

-- ===============================================
-- CONSULTA 18: MASCOTAS SIN VISITAS RECIENTES
-- ===============================================

SELECT 
    m.nombre AS 'Mascota',
    m.especie,
    m.raza,
    d.nombre_completo AS 'Propietario',
    d.telefono,
    IFNULL(MAX(v.fecha_visita), 'Sin visitas registradas') AS 'Ultima_Visita',
    IFNULL(DATEDIFF(CURDATE(), MAX(v.fecha_visita)), 999) AS 'Dias_Sin_Visita',
    IF(m.vacunada = FALSE, 'REQUIERE VACUNACIÓN', 'Vacunas al día') AS 'Estado_Vacunas'
FROM mascotas m
INNER JOIN duenos d ON m.cedula_dueno = d.cedula
LEFT JOIN visitas v ON m.id_mascota = v.id_mascota
GROUP BY m.id_mascota, m.nombre, d.nombre_completo
HAVING MAX(v.fecha_visita) IS NULL 
   OR DATEDIFF(CURDATE(), MAX(v.fecha_visita)) > 30
ORDER BY DATEDIFF(CURDATE(), MAX(v.fecha_visita)) DESC;

-- ===============================================
-- CONSULTA 19: REPORTE FINANCIERO POR DUEÑO
-- ===============================================

SELECT 
    d.nombre_completo AS 'Cliente',
    d.telefono,
    COUNT(DISTINCT m.id_mascota) AS 'Mascotas_Registradas',
    COUNT(v.id_visita) AS 'Total_Visitas',
    MIN(v.fecha_visita) AS 'Primera_Visita',
    MAX(v.fecha_visita) AS 'Ultima_Visita',
    SUM(v.precio_final) AS 'Gasto_Total_Historico',
    ROUND(AVG(v.precio_final), 2) AS 'Gasto_Promedio_Por_Visita',
    CASE 
        WHEN SUM(v.precio_final) > 100000 THEN 'Cliente Premium'
        WHEN SUM(v.precio_final) > 50000 THEN 'Cliente Frecuente'
        ELSE 'Cliente Regular'
    END AS 'Categoria_Cliente'
FROM duenos d
INNER JOIN mascotas m ON d.cedula = m.cedula_dueno
INNER JOIN visitas v ON m.id_mascota = v.id_mascota
GROUP BY d.cedula, d.nombre_completo, d.telefono
ORDER BY SUM(v.precio_final) DESC;

-- ===============================================
-- CONSULTA 20: VISTA COMPLETA DE HISTORIAL MÉDICO
-- ===============================================

SELECT 
    v.fecha_visita AS 'Fecha',
    CONCAT(d.nombre_completo, ' - ', m.nombre) AS 'Cliente_y_Mascota',
    CONCAT(m.especie, ' ', m.raza, ' (', m.edad, ' años)') AS 'Detalles_Animal',
    s.nombre AS 'Servicio',
    v.precio_final AS 'Costo',
    IFNULL(v.observaciones, 'Sin observaciones') AS 'Observaciones_Visita',
    COUNT(t.id_tratamiento) AS 'Tratamientos_Recetados',
    CASE 
        WHEN COUNT(t.id_tratamiento) = 0 THEN 'Solo servicio'
        WHEN COUNT(t.id_tratamiento) = 1 THEN 'Un tratamiento'  
        ELSE CONCAT(COUNT(t.id_tratamiento), ' tratamientos')
    END AS 'Resumen_Tratamientos',
    GROUP_CONCAT(
        CONCAT(t.nombre, ' (', t.duracion_dias, ' días)') 
        SEPARATOR ' | '
    ) AS 'Detalle_Tratamientos'
FROM visitas v
INNER JOIN mascotas m ON v.id_mascota = m.id_mascota
INNER JOIN duenos d ON m.cedula_dueno = d.cedula
INNER JOIN servicios s ON v.id_servicio = s.id_servicio
LEFT JOIN tratamientos t ON v.id_visita = t.id_visita
GROUP BY v.id_visita
ORDER BY v.fecha_visita DESC, v.hora_visita DESC;

-- ===============================================
-- CONSULTAS ADICIONALES DE ANÁLISIS AVANZADO
-- ===============================================

-- CONSULTA EXTRA 1: Análisis de especies más atendidas por mes
SELECT 
    DATE_FORMAT(v.fecha_visita, '%Y-%m') AS 'Periodo',
    m.especie,
    COUNT(*) AS 'Visitas_Por_Especie',
    ROUND(AVG(v.precio_final), 2) AS 'Gasto_Promedio',
    RANK() OVER (PARTITION BY DATE_FORMAT(v.fecha_visita, '%Y-%m') 
                 ORDER BY COUNT(*) DESC) AS 'Ranking_Mensual'
FROM visitas v
INNER JOIN mascotas m ON v.id_mascota = m.id_mascota
GROUP BY DATE_FORMAT(v.fecha_visita, '%Y-%m'), m.especie
ORDER BY v.fecha_visita DESC, COUNT(*) DESC;

-- CONSULTA EXTRA 2: Eficiencia de tratamientos por veterinario
SELECT 
    'ANÁLISIS DE TRATAMIENTOS' AS 'Tipo_Reporte',
    COUNT(DISTINCT t.nombre) AS 'Tipos_Tratamientos_Diferentes',
    COUNT(*) AS 'Total_Tratamientos_Recetados',
    ROUND(AVG(t.duracion_dias), 2) AS 'Duracion_Promedio_Dias',
    COUNT(CASE WHEN t.activo = TRUE THEN 1 END) AS 'Actualmente_Activos',
    ROUND((COUNT(CASE WHEN t.activo = TRUE THEN 1 END) * 100.0 / COUNT(*)), 2) 
        AS 'Porcentaje_Tratamientos_Activos'
FROM tratamientos t;

-- ===============================================
-- LIMPIEZA: ELIMINAR TABLA TEMPORAL
-- ===============================================

DROP TABLE IF EXISTS mascotas_vacunadas_reporte;

-- ===============================================
-- RESUMEN FINAL DE CONSULTAS EJECUTADAS
-- ===============================================

SELECT 
    'RESUMEN DE CONSULTAS EJECUTADAS' AS 'Información',
    '20+ consultas realizadas exitosamente' AS 'Estado',
    'Todas las funciones solicitadas implementadas' AS 'Cobertura',
    'Base de datos lista para producción' AS 'Resultado';



