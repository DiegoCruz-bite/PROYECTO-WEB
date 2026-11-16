USE EncuentroAcademico;
GO
SELECT r.numero, e.cedula, e.nombres, e.apellidos, e.email,
       p.nombre AS Programa, s.descripcion AS Semestre,
       tp.descripcion AS Participacion, t.descripcion AS Tema,
       j.descripcion AS Jornada, r.modalidad, r.fecha_inscripcion, r.comentarios
FROM dbo.Registro AS r
INNER JOIN dbo.Estudiantes AS e ON e.Idestudiante = r.Idestudiante
INNER JOIN dbo.Programas AS p ON p.Idprograma = r.Idprograma
INNER JOIN dbo.Semestre AS s ON s.Idsemestres = r.Idsemestres
INNER JOIN dbo.Tipo_de_participacion AS tp ON tp.Idparticipacion = r.Idparticipacion
INNER JOIN dbo.Tema AS t ON t.Idtema = r.Idtema
INNER JOIN dbo.Jornada AS j ON j.Idjornada = r.Idjornada
ORDER BY r.numero DESC;
GO
