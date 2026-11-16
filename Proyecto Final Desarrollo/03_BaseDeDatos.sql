/* Encuentro Academico - script reproducible para SQL Server
   Usa las tablas del modelo existente. No elimina datos.
   Ejecutar una sola vez en SSMS; puede volver a ejecutarse sin duplicar catálogos. */
IF DB_ID(N'EncuentroAcademico') IS NULL
    CREATE DATABASE EncuentroAcademico;
GO
USE EncuentroAcademico;
GO

IF OBJECT_ID(N'dbo.Estudiantes', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Estudiantes (
        Idestudiante INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Estudiantes PRIMARY KEY,
        cedula VARCHAR(20) NOT NULL CONSTRAINT UQ_Estudiantes_cedula UNIQUE,
        nombres VARCHAR(100) NOT NULL,
        apellidos VARCHAR(100) NOT NULL,
        email VARCHAR(150) NOT NULL,
        telefono VARCHAR(20) NOT NULL,
        fecha_nacimiento DATE NULL,
        genero VARCHAR(30) NULL
    );
END;
GO
IF OBJECT_ID(N'dbo.Programas', N'U') IS NULL
    CREATE TABLE dbo.Programas (Idprograma INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Programas PRIMARY KEY, nombre VARCHAR(100) NOT NULL);
IF OBJECT_ID(N'dbo.Semestre', N'U') IS NULL
    CREATE TABLE dbo.Semestre (Idsemestres INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Semestre PRIMARY KEY, descripcion VARCHAR(50) NOT NULL);
IF OBJECT_ID(N'dbo.Tipo_de_participacion', N'U') IS NULL
    CREATE TABLE dbo.Tipo_de_participacion (Idparticipacion INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Tipo_de_participacion PRIMARY KEY, descripcion VARCHAR(50) NOT NULL);
IF OBJECT_ID(N'dbo.Tema', N'U') IS NULL
    CREATE TABLE dbo.Tema (Idtema INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Tema PRIMARY KEY, descripcion VARCHAR(100) NOT NULL);
IF OBJECT_ID(N'dbo.Jornada', N'U') IS NULL
    CREATE TABLE dbo.Jornada (Idjornada INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Jornada PRIMARY KEY, descripcion VARCHAR(50) NOT NULL);
GO
IF OBJECT_ID(N'dbo.Registro', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Registro (
        numero INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Registro PRIMARY KEY,
        Idestudiante INT NOT NULL CONSTRAINT FK_Registro_Estudiantes REFERENCES dbo.Estudiantes(Idestudiante),
        Idprograma INT NOT NULL CONSTRAINT FK_Registro_Programas REFERENCES dbo.Programas(Idprograma),
        Idsemestres INT NOT NULL CONSTRAINT FK_Registro_Semestre REFERENCES dbo.Semestre(Idsemestres),
        Idparticipacion INT NOT NULL CONSTRAINT FK_Registro_Participacion REFERENCES dbo.Tipo_de_participacion(Idparticipacion),
        Idtema INT NOT NULL CONSTRAINT FK_Registro_Tema REFERENCES dbo.Tema(Idtema),
        Idjornada INT NOT NULL CONSTRAINT FK_Registro_Jornada REFERENCES dbo.Jornada(Idjornada),
        modalidad VARCHAR(20) NULL,
        fecha_inscripcion DATE NULL,
        comentarios VARCHAR(500) NULL
    );
END;
GO

/* Completar campos introducidos en versiones anteriores sin borrar registros. */
IF COL_LENGTH(N'dbo.Estudiantes', N'cedula') IS NULL
    ALTER TABLE dbo.Estudiantes ADD cedula VARCHAR(20) NULL;
IF COL_LENGTH(N'dbo.Estudiantes', N'fecha_nacimiento') IS NULL
    ALTER TABLE dbo.Estudiantes ADD fecha_nacimiento DATE NULL;
IF COL_LENGTH(N'dbo.Estudiantes', N'genero') IS NULL
    ALTER TABLE dbo.Estudiantes ADD genero VARCHAR(30) NULL;
IF COL_LENGTH(N'dbo.Registro', N'modalidad') IS NULL
    ALTER TABLE dbo.Registro ADD modalidad VARCHAR(20) NULL;
IF COL_LENGTH(N'dbo.Registro', N'fecha_inscripcion') IS NULL
    ALTER TABLE dbo.Registro ADD fecha_inscripcion DATE NULL;
GO
IF COL_LENGTH(N'dbo.Estudiantes', N'cedula') IS NOT NULL
BEGIN
    UPDATE dbo.Estudiantes SET cedula = 'SIN-' + CONVERT(VARCHAR(10), Idestudiante) WHERE cedula IS NULL OR LTRIM(RTRIM(cedula)) = '';
    IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.Estudiantes') AND name = N'cedula' AND is_nullable = 1)
        ALTER TABLE dbo.Estudiantes ALTER COLUMN cedula VARCHAR(20) NOT NULL;
    IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = N'UQ_Estudiantes_cedula')
        ALTER TABLE dbo.Estudiantes ADD CONSTRAINT UQ_Estudiantes_cedula UNIQUE (cedula);
END;
GO
/* Datos de catalogo de prueba: insertar solo los valores que hagan falta. */
IF NOT EXISTS (SELECT 1 FROM dbo.Programas WHERE nombre = N'Ingeniería de Sistemas') INSERT dbo.Programas(nombre) VALUES (N'Ingeniería de Sistemas');
IF NOT EXISTS (SELECT 1 FROM dbo.Programas WHERE nombre = N'Ingeniería Informática') INSERT dbo.Programas(nombre) VALUES (N'Ingeniería Informática');
IF NOT EXISTS (SELECT 1 FROM dbo.Programas WHERE nombre = N'Matemáticas') INSERT dbo.Programas(nombre) VALUES (N'Matemáticas');
IF NOT EXISTS (SELECT 1 FROM dbo.Programas WHERE nombre = N'Física') INSERT dbo.Programas(nombre) VALUES (N'Física');
DECLARE @i INT = 1;
WHILE @i <= 10
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.Semestre WHERE descripcion = CONVERT(VARCHAR(2), @i))
        INSERT dbo.Semestre(descripcion) VALUES (CONVERT(VARCHAR(2), @i));
    SET @i += 1;
END;
IF NOT EXISTS (SELECT 1 FROM dbo.Tipo_de_participacion WHERE descripcion = 'Ponencia') INSERT dbo.Tipo_de_participacion(descripcion) VALUES ('Ponencia');
IF NOT EXISTS (SELECT 1 FROM dbo.Tipo_de_participacion WHERE descripcion = 'Asistente') INSERT dbo.Tipo_de_participacion(descripcion) VALUES ('Asistente');
IF NOT EXISTS (SELECT 1 FROM dbo.Tema WHERE descripcion = N'Inteligencia Artificial') INSERT dbo.Tema(descripcion) VALUES (N'Inteligencia Artificial');
IF NOT EXISTS (SELECT 1 FROM dbo.Tema WHERE descripcion = 'Big Data') INSERT dbo.Tema(descripcion) VALUES ('Big Data');
IF NOT EXISTS (SELECT 1 FROM dbo.Tema WHERE descripcion = 'Ciberseguridad') INSERT dbo.Tema(descripcion) VALUES ('Ciberseguridad');
IF NOT EXISTS (SELECT 1 FROM dbo.Tema WHERE descripcion = N'Computación en la Nube') INSERT dbo.Tema(descripcion) VALUES (N'Computación en la Nube');
IF NOT EXISTS (SELECT 1 FROM dbo.Jornada WHERE descripcion = N'Mañana') INSERT dbo.Jornada(descripcion) VALUES (N'Mañana');
IF NOT EXISTS (SELECT 1 FROM dbo.Jornada WHERE descripcion = 'Tarde') INSERT dbo.Jornada(descripcion) VALUES ('Tarde');
GO

/* Comprobacion rapida del esquema y catalogos. */
SELECT 'Estudiantes' AS Tabla, COUNT(*) AS Registros FROM dbo.Estudiantes
UNION ALL SELECT 'Registro', COUNT(*) FROM dbo.Registro
UNION ALL SELECT 'Programas', COUNT(*) FROM dbo.Programas
UNION ALL SELECT 'Semestre', COUNT(*) FROM dbo.Semestre
UNION ALL SELECT 'Tipo_de_participacion', COUNT(*) FROM dbo.Tipo_de_participacion
UNION ALL SELECT 'Tema', COUNT(*) FROM dbo.Tema
UNION ALL SELECT 'Jornada', COUNT(*) FROM dbo.Jornada;
GO


/* gestion actividades */
IF OBJECT_ID(N'dbo.TipoActividad',N'U') IS NULL CREATE TABLE dbo.TipoActividad(Id INT IDENTITY PRIMARY KEY,Nombre NVARCHAR(50) NOT NULL UNIQUE);
IF OBJECT_ID(N'dbo.ActividadAcademica',N'U') IS NULL CREATE TABLE dbo.ActividadAcademica(Id INT IDENTITY PRIMARY KEY,Titulo NVARCHAR(150) NOT NULL,Descripcion NVARCHAR(1000) NOT NULL,TipoId INT NOT NULL REFERENCES dbo.TipoActividad(Id),FechaInicio DATE NOT NULL,FechaFin DATE NOT NULL,HoraInicio TIME NOT NULL,HoraFin TIME NOT NULL,Modalidad NVARCHAR(30) NOT NULL,Lugar NVARCHAR(150) NOT NULL,Cupos INT NOT NULL,Estado NVARCHAR(20) NOT NULL DEFAULT N'Próxima',CreadaEn DATETIME2 NOT NULL DEFAULT SYSDATETIME(),CHECK(Cupos>0),CHECK(FechaFin>=FechaInicio),CHECK(HoraFin>HoraInicio));
IF OBJECT_ID(N'dbo.InscripcionActividad',N'U') IS NULL CREATE TABLE dbo.InscripcionActividad(Id INT IDENTITY PRIMARY KEY,ActividadId INT NOT NULL REFERENCES dbo.ActividadAcademica(Id),EstudianteId INT NOT NULL REFERENCES dbo.Estudiantes(Idestudiante),FechaInscripcion DATETIME2 NOT NULL DEFAULT SYSDATETIME(),Estado NVARCHAR(20) NOT NULL DEFAULT N'Confirmada',CONSTRAINT UQ_Inscripcion UNIQUE(ActividadId,EstudianteId));
IF OBJECT_ID(N'dbo.UsuarioAcceso',N'U') IS NULL CREATE TABLE dbo.UsuarioAcceso(Id INT IDENTITY PRIMARY KEY,Nombre NVARCHAR(100) NOT NULL,Correo NVARCHAR(150) NOT NULL UNIQUE,PasswordHash VARBINARY(32) NOT NULL,Salt VARBINARY(16) NOT NULL,Iteraciones INT NOT NULL DEFAULT 100000,Rol NVARCHAR(30) NOT NULL DEFAULT N'Administrador',Activo BIT NOT NULL DEFAULT 1);
IF NOT EXISTS(SELECT 1 FROM dbo.TipoActividad) INSERT dbo.TipoActividad(Nombre) VALUES(N'Taller'),(N'Conferencia'),(N'Seminario'),(N'Curso'),(N'Encuentro');
IF NOT EXISTS(SELECT 1 FROM dbo.UsuarioAcceso WHERE Correo=N'admin@unicampus.edu') INSERT dbo.UsuarioAcceso(Nombre,Correo,PasswordHash,Salt,Iteraciones,Rol) VALUES(N'Administración UniCampus',N'admin@unicampus.edu',0x096C37012A844E545E4A0B95F69F45648D4A1D2592D4A290C686E303DA6D98C8,0x00112233445566778899AABBCCDDEEFF,100000,N'Administrador');
GO
/* Registros ficticios para que el panel tenga datos demostrativos. */
IF NOT EXISTS(SELECT 1 FROM dbo.Estudiantes WHERE cedula='9999999901') INSERT dbo.Estudiantes(cedula,nombres,apellidos,email,telefono,fecha_nacimiento,genero) VALUES('9999999901','Ana','Torres','ana.torres.demo@ejemplo.edu','3000000001','2002-03-12','Femenino');
IF NOT EXISTS(SELECT 1 FROM dbo.Estudiantes WHERE cedula='9999999902') INSERT dbo.Estudiantes(cedula,nombres,apellidos,email,telefono,fecha_nacimiento,genero) VALUES('9999999902','Carlos','Pérez','carlos.perez.demo@ejemplo.edu','3000000002','2001-08-21','Masculino');
IF NOT EXISTS(SELECT 1 FROM dbo.Estudiantes WHERE cedula='9999999903') INSERT dbo.Estudiantes(cedula,nombres,apellidos,email,telefono,fecha_nacimiento,genero) VALUES('9999999903','Laura','Gómez','laura.gomez.demo@ejemplo.edu','3000000003','2003-01-05','Femenino');
IF NOT EXISTS(SELECT 1 FROM dbo.ActividadAcademica WHERE Titulo=N'Taller de Programación Web') INSERT dbo.ActividadAcademica(Titulo,Descripcion,TipoId,FechaInicio,FechaFin,HoraInicio,HoraFin,Modalidad,Lugar,Cupos,Estado) SELECT N'Taller de Programación Web',N'Espacio práctico para reforzar conceptos de programación web.',Id,'2026-11-18','2026-11-18','08:00','12:00',N'Presencial',N'Laboratorio 3',30,N'Activa' FROM dbo.TipoActividad WHERE Nombre=N'Taller';
IF NOT EXISTS(SELECT 1 FROM dbo.ActividadAcademica WHERE Titulo=N'Conferencia de Inteligencia Artificial') INSERT dbo.ActividadAcademica(Titulo,Descripcion,TipoId,FechaInicio,FechaFin,HoraInicio,HoraFin,Modalidad,Lugar,Cupos,Estado) SELECT N'Conferencia de Inteligencia Artificial',N'Tendencias y aplicaciones de IA en la educación.',Id,'2026-11-20','2026-11-20','10:00','12:00',N'Híbrida',N'Auditorio Central',100,N'Próxima' FROM dbo.TipoActividad WHERE Nombre=N'Conferencia';
IF NOT EXISTS(SELECT 1 FROM dbo.ActividadAcademica WHERE Titulo=N'Seminario de Bases de Datos') INSERT dbo.ActividadAcademica(Titulo,Descripcion,TipoId,FechaInicio,FechaFin,HoraInicio,HoraFin,Modalidad,Lugar,Cupos,Estado) SELECT N'Seminario de Bases de Datos',N'Prácticas de modelado y consultas SQL.',Id,'2026-11-25','2026-11-25','14:00','17:00',N'Presencial',N'Laboratorio 2',50,N'Próxima' FROM dbo.TipoActividad WHERE Nombre=N'Seminario';
INSERT dbo.InscripcionActividad(ActividadId,EstudianteId) SELECT a.Id,e.Idestudiante FROM dbo.ActividadAcademica a CROSS JOIN dbo.Estudiantes e WHERE a.Titulo=N'Taller de Programación Web' AND e.cedula IN('9999999901','9999999902') AND NOT EXISTS(SELECT 1 FROM dbo.InscripcionActividad i WHERE i.ActividadId=a.Id AND i.EstudianteId=e.Idestudiante);
GO
