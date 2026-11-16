using System;
using System.Data;
using System.Text.RegularExpressions;
using EncuentroAcademico.DAL;
using EncuentroAcademico.Entities;

namespace EncuentroAcademico.BLL
{
    public sealed class RegistroService
    {
        private readonly RegistroRepository _repository;
        public RegistroService() { _repository = new RegistroRepository(); }

        public CatalogosDto ObtenerCatalogos() { return _repository.ObtenerCatalogos(); }
        public DataTable Listar() { return _repository.Listar(); }
        public RegistroFormularioDto Obtener(int numero)
        {
            if (numero <= 0) throw new ArgumentException("Selecciona un registro válido.");
            return _repository.Obtener(numero);
        }
        public int Crear(RegistroFormularioDto item)
        {
            Validar(item);
            return _repository.Crear(item);
        }
        public void Actualizar(RegistroFormularioDto item)
        {
            if (item == null || item.Numero <= 0) throw new ArgumentException("Selecciona el registro que deseas actualizar.");
            Validar(item);
            _repository.Actualizar(item);
        }
        public void Eliminar(int numero)
        {
            if (numero <= 0) throw new ArgumentException("Selecciona un registro válido.");
            _repository.Eliminar(numero);
        }

        private static void Validar(RegistroFormularioDto item)
        {
            if (item == null) throw new ArgumentException("Completa los datos del formulario.");
            if (string.IsNullOrWhiteSpace(item.Cedula) || item.Cedula.Trim().Length > 20 || !Regex.IsMatch(item.Cedula.Trim(), "^[0-9]{5,20}$"))
                throw new ArgumentException("La cédula debe contener entre 5 y 20 dígitos.");
            if (string.IsNullOrWhiteSpace(item.Nombres) || item.Nombres.Trim().Length > 100) throw new ArgumentException("Escribe nombres válidos.");
            if (string.IsNullOrWhiteSpace(item.Apellidos) || item.Apellidos.Trim().Length > 100) throw new ArgumentException("Escribe apellidos válidos.");
            if (string.IsNullOrWhiteSpace(item.Correo) || item.Correo.Length > 150 || !Regex.IsMatch(item.Correo.Trim(), @"^[^\s@]+@[^\s@]+\.[^\s@]+$"))
                throw new ArgumentException("Escribe un correo electrónico válido.");
            if (string.IsNullOrWhiteSpace(item.Telefono) || item.Telefono.Length > 20 || !Regex.IsMatch(item.Telefono.Trim(), "^[0-9+() -]{7,20}$"))
                throw new ArgumentException("Escribe un teléfono válido.");
            if (item.FechaNacimiento.Date >= DateTime.Today) throw new ArgumentException("La fecha de nacimiento debe ser anterior a hoy.");
            int edad = DateTime.Today.Year - item.FechaNacimiento.Year;
            if (item.FechaNacimiento.Date > DateTime.Today.AddYears(-edad)) edad--;
            if (edad < 15 || edad > 80) throw new ArgumentException("La edad debe estar entre 15 y 80 años.");
            if (string.IsNullOrWhiteSpace(item.Genero) || item.Genero.Length > 30) throw new ArgumentException("Selecciona un género.");
            if (item.ProgramaId <= 0 || item.SemestreId <= 0 || item.ParticipacionId <= 0 || item.TemaId <= 0 || item.JornadaId <= 0)
                throw new ArgumentException("Selecciona programa, semestre, participación, tema y jornada.");
            if (item.Modalidad != "Presencial" && item.Modalidad != "Virtual") throw new ArgumentException("Selecciona una modalidad válida.");
            if (item.FechaInscripcion.Date < DateTime.Today) throw new ArgumentException("La fecha de inscripción no puede ser anterior a hoy.");
            if (item.Comentarios != null && item.Comentarios.Length > 500) throw new ArgumentException("Los comentarios no pueden superar 500 caracteres.");
        }
    }
}
