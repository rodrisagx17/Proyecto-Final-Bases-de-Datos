/*SIMPLE QUERIES*/






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






