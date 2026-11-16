/* =========================================================
   Agrega la columna "cedula" a la tabla Estudiantes.
   Solo se necesita si la base se creó con una versión anterior
   de 01_BaseDeDatos.sql (sin cédula). Ejecutar en SSMS con F5.
   ========================================================= */
USE EncuentroAcademico;
GO

IF COL_LENGTH('Estudiantes', 'cedula') IS NULL
BEGIN
    ALTER TABLE Estudiantes ADD cedula VARCHAR(20) NULL;
END
GO

-- Los estudiantes que ya existían quedan con una cédula temporal (se corrige con ACTUALIZAR)
UPDATE Estudiantes
SET cedula = 'SIN-' + CAST(Idestudiante AS VARCHAR(10))
WHERE cedula IS NULL;

ALTER TABLE Estudiantes ALTER COLUMN cedula VARCHAR(20) NOT NULL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'UQ_Estudiantes_cedula')
BEGIN
    ALTER TABLE Estudiantes ADD CONSTRAINT UQ_Estudiantes_cedula UNIQUE (cedula);
END
GO
