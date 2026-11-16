/* =========================================================
   Agrega los campos nuevos del registro:
   - Estudiantes: fecha_nacimiento, genero
   - Registro:    modalidad, fecha_inscripcion
   Solo se necesita si la base se creó con una versión anterior
   de 01_BaseDeDatos.sql. Ejecutar en SSMS con F5.
   ========================================================= */
USE EncuentroAcademico;
GO

IF COL_LENGTH('Estudiantes', 'fecha_nacimiento') IS NULL
    ALTER TABLE Estudiantes ADD fecha_nacimiento DATE NULL;

IF COL_LENGTH('Estudiantes', 'genero') IS NULL
    ALTER TABLE Estudiantes ADD genero VARCHAR(30) NULL;

IF COL_LENGTH('Registro', 'modalidad') IS NULL
    ALTER TABLE Registro ADD modalidad VARCHAR(20) NULL;

IF COL_LENGTH('Registro', 'fecha_inscripcion') IS NULL
    ALTER TABLE Registro ADD fecha_inscripcion DATE NULL;
GO
