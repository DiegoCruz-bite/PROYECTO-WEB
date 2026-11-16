using System;
using System.Data;

namespace EncuentroAcademico.Entities
{
    public sealed class CatalogosDto
    {
        public DataTable Programas { get; set; }
        public DataTable Semestres { get; set; }
        public DataTable Jornadas { get; set; }
        public DataTable Temas { get; set; }
        public DataTable Participaciones { get; set; }
    }

    public sealed class RegistroFormularioDto
    {
        public int Numero { get; set; }
        public string Cedula { get; set; }
        public string Nombres { get; set; }
        public string Apellidos { get; set; }
        public string Correo { get; set; }
        public string Telefono { get; set; }
        public DateTime FechaNacimiento { get; set; }
        public string Genero { get; set; }
        public int ProgramaId { get; set; }
        public int SemestreId { get; set; }
        public int ParticipacionId { get; set; }
        public int TemaId { get; set; }
        public int JornadaId { get; set; }
        public string Modalidad { get; set; }
        public DateTime FechaInscripcion { get; set; }
        public string Comentarios { get; set; }
    }
}
