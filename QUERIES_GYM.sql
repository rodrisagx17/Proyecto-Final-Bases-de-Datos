/*SIMPLE QUERIES*/
/*#1_ Esta consulta muestra datos especificos que podrian ser relevantes para identificar una Sede*/
SELECT Nombre, HoraAbre, HoraCierra, Ciudad, EstadoP FROM gym.Sede ORDER BY Ciudad;
/*#2_ Esta consulta sirve para crear un reporte de asistencias diarias durante una semana en especifico*/
SELECT a.Fecha, COUNT(a.CodUserUS) AS Asistencias, SUM(CASE WHEN a.Tipo = 'Clase' THEN 1 ELSE 0 END) AS Clases, SUM(CASE WHEN a.Tipo = 'Libre' THEN 1 ELSE 0 END) AS Libre FROM Asistencia a WHERE a.Fecha BETWEEN '2024-01-25' AND '2024-01-31' GROUP BY a.Fecha ORDER BY a.Fecha;
/*#3_ Esta consulta lista el equipamiento disponible por categoria*/
SELECT Categoria, Nombre, TipoEquip, CantidadAct, Condicion, UltMantenim FROM gym.Equipamiento WHERE Condicion = 'Disponible' ORDER BY Categoria, Nombre;
/*#4_ Esta consulta muestra los usuarios registrados en Enero de 2024*/
SELECT CodUser, Genero, FechaNac, FechaInscrip, HoraInscrip FROM gym.Usuario WHERE FechaInscrip BETWEEN '2024-01-01' AND '2024-01-31' ORDER BY FechaInscrip;
/*#5_ Esta consulta muestra el equipo que requiere mantenimiento*/
SELECT Nombre, Categoria, TipoEquip, Condicion, UltMantenim FROM gym.Equipamiento WHERE Condicion = 'En Mantenimiento' ORDER BY UltMantenim;


/*MULTITABLE QUERIES*/
/*#1_ Esta consulta muestra información completa de usuarios con sus membresías y pagos*/
SELECT u.CodUser, CONCAT(p.NombreP, ' ', p.NombreS, ' ', p.AP, ' ', p.AM) AS NombreCompleto, p.Email, m.Nombre AS TipoMembresia, m.precio AS PrecioMembresia, m.FechaInicio, m.FechaVen, pa.Monto AS MontoAPagar, pa.MontoRe AS MontoPagado, pa.MontoAdeu AS MontoAdeudado, pa.EstadoPago, pa.FechaPago FROM gym.Usuario u INNER JOIN UsuarioPersona up ON u.CodUser = up.CodUserUS
INNER JOIN gym.Persona p ON up.IdenPersona = p.IdenOf
INNER JOIN gym.Membresia m ON u.CodUser = m.CodUserUS
LEFT JOIN gym.Pago pa ON m.CodMemb = pa.Memb
ORDER BY u.CodUser;
/*#2_ Esta consulta muestra empleados con sus especialidades y clases asignadas*/
SELECT e.CodEmpl, CONCAT(p.NombreP, ' ', p.NombreS, ' ', p.AP) AS NombreInstructor, e.Rol, e.Especialidad, s.Nombre AS Sede, c.Nombre AS NombreClase, c.Descripcion AS DescripcionClase, c.Fecha AS FechaClase, c.HoraInicio, c.HoraFin, z.Nombre AS ZonaClase, ec.TarifaXClase FROM gym.Empleado e
INNER JOIN gym.EmpleadoPersona ep ON e.CodEmpl = ep.CodEmplEM
INNER JOIN gym.Persona p ON ep.IdenPersona = p.IdenOf
INNER JOIN gym.EmpleadoXClase ec ON e.CodEmpl = ec.CodEmplEM
INNER JOIN gym.Clase c ON ec.IDClase = c.IDClase
INNER JOIN gym.Sede s ON c.IDSede = s.IDSede
INNER JOIN gym.Zona z ON c.IDZona = z.IDZona AND c.IDSede = z.IDSede
ORDER BY e.CodEmpl, c.Fecha;
/*#3_ Esta consulta muestra la asistencia de usuarios a clases con detalles completos*/
SELECT CONCAT(p.NombreP, ' ', p.AP) AS NombreUsuario, s.Nombre AS Sede, s.Ciudad, z.Nombre AS Zona, c.Nombre AS ClaseAsistida, a.Fecha AS FechaAsistencia, a.HoraEntrada, a.HoraSalida, a.Tipo AS TipoAsistencia, uc.Estado AS EstadoInscripcion, uc.Calificacion FROM gym.Asistencia a
INNER JOIN gym.Usuario u ON a.CodUserUS = u.CodUser
INNER JOIN gym.UsuarioPersona up ON u.CodUser = up.CodUserUS
INNER JOIN gym.Persona p ON up.IdenPersona = p.IdenOf
INNER JOIN gym.Sede s ON a.IDSede = s.IDSede
INNER JOIN gym.Zona z ON a.IDZona = z.IDZona AND a.IDSede = z.IDSede
LEFT JOIN gym.Clase c ON a.IDClase = c.IDClase
LEFT JOIN gym.UsuarioXClase uc ON u.CodUser = uc.CodUserUS AND c.IDClase = uc.IDClase
ORDER BY a.Fecha DESC, a.HoraEntrada;
/*#4_ Esta consulta muestra el estado del equipamiento por sede con información de mantenimiento*/
SELECT s.Nombre AS Sede, s.Ciudad, z.Nombre AS Zona, eq.Nombre AS Equipamiento, eq.Categoria, eq.TipoEquip, eq.CantidadAct, eq.Condicion AS EstadoEquipo, eq.UltMantenim AS UltimoMantenimiento, m.Descripcion AS DescripcionMantenimiento, m.Estado AS EstadoMantenimiento, m.FechaInicio AS InicioMantenimiento, m.FechaFin AS FinMantenimiento, CONCAT(pe.NombreP, ' ', pe.AP) AS ResponsableMantenimiento FROM gym.Sede s
INNER JOIN gym.ZonaEquipamiento ze ON s.IDSede = ze.SedeID
INNER JOIN gym.Zona z ON ze.ZonaID = z.IDZona AND s.IDSede = z.IDSede
INNER JOIN gym.Equipamiento eq ON ze.EquipamientoID = eq.IDEquip
LEFT JOIN gym.Mantenimiento m ON eq.IDEquip = m.EquipIDE
LEFT JOIN gym.EmpleadoXManten em ON m.IDManten = em.MantenimientoID
LEFT JOIN gym.Empleado e ON em.CodEmplEM = e.CodEmpl
LEFT JOIN gym.EmpleadoPersona ep ON e.CodEmpl = ep.CodEmplEM
LEFT JOIN gym.Persona pe ON ep.IdenPersona = pe.IdenOf
ORDER BY s.Nombre, z.Nombre, eq.Nombre;
/*#5_ Esta consulta muestra el Reporte financiero por sede con ingresos y gastos*/
SELECT s.Nombre AS Sede, s.Ciudad, s.EstadoP, COUNT(DISTINCT u.CodUser) AS TotalUsuarios, COUNT(DISTINCT c.IDCita) AS TotalCitas, SUM(pa.MontoRe) AS IngresosPorPagos, AVG(pa.MontoRe) AS PromedioIngresoPorPago, COUNT(DISTINCT m.IDManten) AS MantenimientosRealizados, SUM(em.CostoEstimado) AS CostoEstimadoMantenimiento, (SUM(pa.MontoRe) - COALESCE(SUM(em.CostoEstimado), 0)) AS UtilidadEstimada, GROUP_CONCAT(DISTINCT CONCAT(pe.NombreP, ' ', pe.AP) SEPARATOR ', ') AS EmpleadosActivos
FROM gym.Sede s
LEFT JOIN gym.cita c ON s.IDSede = c.IDSede
LEFT JOIN gym.Usuario u ON c.CodUserUS = u.CodUser
LEFT JOIN gym.Membresia me ON u.CodUser = me.CodUserUS
LEFT JOIN gym.Pago pa ON me.CodMemb = pa.Memb
LEFT JOIN gym.ZonaEquipamiento ze ON s.IDSede = ze.SedeID
LEFT JOIN gym.EquipXManten em ON ze.EquipamientoID = em.EquipamientoID
LEFT JOIN gym.Mantenimiento m ON em.MantenimientoID = m.IDManten
LEFT JOIN gym.EmpleadoXManten emm ON m.IDManten = emm.MantenimientoID
LEFT JOIN gym.Empleado emp ON emm.CodEmplEM = emp.CodEmpl
LEFT JOIN gym.EmpleadoPersona ep ON emp.CodEmpl = ep.CodEmplEM
LEFT JOIN gym.Persona pe ON ep.IdenPersona = pe.IdenOf
WHERE emp.ActivoEmple = TRUE OR emp.ActivoEmple IS NULL
GROUP BY s.IDSede, s.Nombre, s.Ciudad, s.EstadoP
ORDER BY UtilidadEstimada DESC;
/* 6 Muestra usuarios activos con sus días de asistencia y frecuencia */
SELECT CONCAT(p.NombreP, ' ', p.AP) AS Nombre, p.Email, GROUP_CONCAT(DISTINCT da.DiasSem ORDER BY da.DiasSem SEPARATOR ', ') AS Dias_Asistencia, COUNT(a.ID) AS Total_Visitas, MAX(a.Fecha) AS Ultima_Visita FROM gym.Usuario u
INNER JOIN gym.UsuarioPersona up ON u.CodUser = up.CodUserUS
INNER JOIN gym.Persona p ON up.IdenPersona = p.IdenOf
LEFT JOIN gym.DiasAsis da ON u.CodUser = da.CodUserUS
LEFT JOIN gym.Asistencia a ON u.CodUser = a.CodUserUS
WHERE p.Activo = TRUE
GROUP BY u.CodUser
ORDER BY Total_Visitas DESC;
/* 7 Muestra clases con cupos disponibles y equipamiento necesario */
SELECT c.Nombre AS Clase, s.Nombre AS Sede, z.Nombre AS Zona, c.NumPartic AS Capacidad, (c.NumPartic - COUNT(uc.IDClase)) AS Cupos_Disponibles, GROUP_CONCAT(DISTINCT eq.Nombre SEPARATOR ', ') AS Equipamiento_Necesario FROM gym.Clase c
INNER JOIN gym.Zona z ON c.IDZona = z.ID AND c.IDSede = z.IDSede
INNER JOIN gym.Sede s ON c.IDSede = s.ID
LEFT JOIN gym.UsuarioXClase uc ON c.ID = uc.IDClase
LEFT JOIN gym.ZonaEquipamiento ze ON z.ID = ze.ZonaID AND s.ID = ze.SedeID
LEFT JOIN gym.Equipamiento eq ON ze.EquipamientoID = eq.ID
GROUP BY c.ID
HAVING Cupos_Disponibles > 0;
/* 8 Lista todo el mantenimiento pendiente con técnicos asignados */
SELECT eq.Nombre AS Equipo, m.Descripcion, m.Estado, m.FechaInicio, CONCAT(p.NombreP, ' ', p.AP) AS Tecnico, emx.TipoResponsabilidad, s.Nombre AS Sede_Ubicacion FROM gym.Mantenimiento m
INNER JOIN gym.Equipamiento eq ON m.EquipIDE = eq.ID
INNER JOIN gym.EmpleadoXManten emx ON m.ID = emx.MantenimientoID
INNER JOIN gym.Empleado e ON emx.CodEmplEM = e.CodEmpl
INNER JOIN gym.EmpleadoPersona ep ON e.CodEmpl = ep.CodEmplEM
INNER JOIN gym.Persona p ON ep.IdenPersona = p.IdenOf
INNER JOIN gym.ZonaEquipamiento ze ON eq.ID = ze.EquipamientoID
INNER JOIN gym.Sede s ON ze.SedeID = s.ID
WHERE m.Estado IN ('Agendado', 'En Proceso')
ORDER BY m.FechaInicio;
/* 9 Evalúa instructores basado en asistencia y calificaciones */
SELECT CONCAT(p.NombreP, ' ', p.AP) AS Instructor, c.Nombre AS Clase, COUNT(ec.IDClase) AS Clases_Impartidas, AVG(uc.Calificacion) AS Puntuacion_Media, COUNT(a.ID) AS Asistencias_Totales FROM gym.EmpleadoXClase ec
INNER JOIN gym.Empleado e ON ec.CodEmplEM = e.CodEmpl
INNER JOIN gym.EmpleadoPersona ep ON e.CodEmpl = ep.CodEmplEM
INNER JOIN gym.Persona p ON ep.IdenPersona = p.IdenOf
INNER JOIN gym.Clase c ON ec.IDClase = c.ID
LEFT JOIN gym.UsuarioXClase uc ON c.ID = uc.IDClase
LEFT JOIN gym.Asistencia a ON c.ID = a.IDClase
WHERE e.Rol = 'Instructor'
GROUP BY ec.CodEmplEM, c.ID
ORDER BY Puntuacion_Media DESC;
/* 10 Identifica membresías por expirar con datos de contacto */
SELECT CONCAT(p.NombreP, ' ', p.AP) AS Miembro, p.Email, tp.Numero AS Telefono, m.Nombre AS Membresia, m.FechaVen AS Expiracion, DATEDIFF(m.FechaVen, CURDATE()) AS Dias_Restantes, pa.Metodo AS Ultimo_Pago FROM gym.Membresia m
INNER JOIN gym.Usuario u ON m.CodUserUS = u.CodUser
INNER JOIN gym.UsuarioPersona up ON u.CodUser = up.CodUserUS
INNER JOIN gym.Persona p ON up.IdenPersona = p.IdenOf
LEFT JOIN gym.TelefonoPersona tp ON p.IdenOf = tp.IDPersona
LEFT JOIN gym.Pago pa ON m.CodMemb = pa.Memb
WHERE m.EstadoPlan = 'Activo'
AND m.FechaVen BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)
ORDER BY Dias_Restantes;
