using System;
using System.Data;
using System.Security.Cryptography;
using EncuentroAcademico.DAL;

namespace EncuentroAcademico.BLL
{
    public sealed class AcademicoService
    {
        readonly AcademicoRepository repo = new AcademicoRepository();
        public DataTable Resumen(){return repo.Resumen();} public DataTable Agenda(){return repo.Agenda();} public DataTable Tipos(){return repo.Tipos();} public DataTable Actividades(string q){return repo.Actividades(q??String.Empty);} public DataTable Estudiantes(){return repo.Estudiantes();} public DataTable ActividadesCombo(){return repo.ActividadesCombo();} public DataTable Inscripciones(){return repo.Inscripciones();} public DataTable ObtenerActividad(int id){return repo.ObtenerActividad(id);}
        public string Autenticar(string correo,string clave){if(String.IsNullOrWhiteSpace(correo)||String.IsNullOrEmpty(clave))return null;DataTable t=repo.Cuenta(correo.Trim());if(t.Rows.Count==0)return null;DataRow r=t.Rows[0];byte[] expected=(byte[])r["PasswordHash"],salt=(byte[])r["Salt"],got;using(var k=new Rfc2898DeriveBytes(clave,salt,Convert.ToInt32(r["Iteraciones"])))got=k.GetBytes(expected.Length);int diff=0;for(int i=0;i<got.Length;i++)diff|=got[i]^expected[i];return diff==0?Convert.ToString(r["Nombre"]):null;}
        public void GuardarActividad(int id,string titulo,string desc,int tipo,string fechaInicio,string fechaFin,string horaInicio,string horaFin,string modalidad,string lugar,string cupos,string estado){if(String.IsNullOrWhiteSpace(titulo)||titulo.Trim().Length>150)throw new ArgumentException("El título es obligatorio y admite hasta 150 caracteres.");if(String.IsNullOrWhiteSpace(desc)||desc.Trim().Length>1000)throw new ArgumentException("La descripción es obligatoria y admite hasta 1000 caracteres.");if(String.IsNullOrWhiteSpace(lugar)||lugar.Trim().Length>150)throw new ArgumentException("Indica el lugar o enlace (máximo 150 caracteres).");DateTime fi,ff;TimeSpan hi,hf;int cup;if(!DateTime.TryParse(fechaInicio,out fi)||!DateTime.TryParse(fechaFin,out ff)||ff.Date<fi.Date)throw new ArgumentException("Revisa las fechas de inicio y fin.");if(!TimeSpan.TryParse(horaInicio,out hi)||!TimeSpan.TryParse(horaFin,out hf)||hf<=hi)throw new ArgumentException("La hora final debe ser posterior a la inicial.");if(!Int32.TryParse(cupos,out cup)||cup<1)throw new ArgumentException("Los cupos deben ser un entero mayor que cero.");if(tipo<1)throw new ArgumentException("Selecciona un tipo de actividad.");if(modalidad!="Presencial"&&modalidad!="Virtual"&&modalidad!="Híbrida")throw new ArgumentException("Modalidad no válida.");if(estado!="Próxima"&&estado!="Activa"&&estado!="Finalizada"&&estado!="Cancelada")throw new ArgumentException("Estado no válido.");repo.Guardar(id,titulo.Trim(),desc.Trim(),tipo,fi,ff,hi,hf,modalidad,lugar.Trim(),cup,estado);}
        public void CancelarActividad(int id){if(id<=0)throw new ArgumentException("Actividad no válida.");repo.CancelarActividad(id);}
        public bool Inscribir(int actividad,int estudiante){if(actividad<=0||estudiante<=0)throw new ArgumentException("Selecciona actividad y estudiante.");return repo.Inscribir(actividad,estudiante);}
        public void CancelarInscripcion(int id){if(id<=0)throw new ArgumentException("Inscripción no válida.");repo.CancelarInscripcion(id);}
    }
}
