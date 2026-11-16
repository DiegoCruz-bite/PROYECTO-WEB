using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace EncuentroAcademico.DAL
{
    public sealed class AcademicoRepository
    {
        readonly string cs;
        public AcademicoRepository(){var s=ConfigurationManager.ConnectionStrings["conexionDB"];if(s==null)throw new ConfigurationErrorsException("Falta conexionDB.");cs=s.ConnectionString;}
        DataTable Query(string sql, params SqlParameter[] p){using(var c=new SqlConnection(cs))using(var a=new SqlDataAdapter(sql,c)){if(p!=null)foreach(var x in p)a.SelectCommand.Parameters.Add(x);var t=new DataTable();a.Fill(t);return t;}}
        void Exec(string sql, params SqlParameter[] p){using(var c=new SqlConnection(cs))using(var x=new SqlCommand(sql,c)){if(p!=null)foreach(var q in p)x.Parameters.Add(q);c.Open();x.ExecuteNonQuery();}}
        SqlParameter P(string n,SqlDbType t,object v){return new SqlParameter(n,t){Value=v??DBNull.Value};}
        public DataTable Resumen(){return Query("SELECT (SELECT COUNT(*) FROM dbo.ActividadAcademica) Total,(SELECT COUNT(*) FROM dbo.InscripcionActividad WHERE Estado=N'Confirmada') Inscritos,(SELECT COUNT(*) FROM dbo.ActividadAcademica WHERE FechaInicio>=CONVERT(date,GETDATE()) AND Estado<>N'Cancelada') Proximas,(SELECT COUNT(*) FROM dbo.ActividadAcademica WHERE FechaFin<CONVERT(date,GETDATE())) Finalizadas");}
        public DataTable Agenda(){return Query("SELECT TOP 6 a.Titulo,t.Nombre Tipo,a.FechaInicio,a.Modalidad,a.Estado,a.Cupos-ISNULL(i.N,0) Disponibles FROM dbo.ActividadAcademica a JOIN dbo.TipoActividad t ON t.Id=a.TipoId OUTER APPLY(SELECT COUNT(*) N FROM dbo.InscripcionActividad WHERE ActividadId=a.Id AND Estado=N'Confirmada') i ORDER BY a.FechaInicio");}
        public DataTable Tipos(){return Query("SELECT Id,Nombre FROM dbo.TipoActividad ORDER BY Nombre");}
        public DataTable Actividades(string q){return Query("SELECT a.Id,a.Titulo,t.Nombre Tipo,a.FechaInicio,a.FechaFin,a.HoraInicio,a.HoraFin,a.Modalidad,a.Lugar,a.Cupos,a.Estado FROM dbo.ActividadAcademica a JOIN dbo.TipoActividad t ON t.Id=a.TipoId WHERE a.Titulo LIKE @q ORDER BY a.FechaInicio",P("@q",SqlDbType.NVarChar,"%"+q+"%"));}
        public DataTable Estudiantes(){return Query("SELECT Idestudiante Id,nombres+' '+apellidos Nombre FROM dbo.Estudiantes ORDER BY nombres");}
        public DataTable ActividadesCombo(){return Query("SELECT Id,Titulo FROM dbo.ActividadAcademica WHERE Estado<>N'Cancelada' ORDER BY FechaInicio");}
        public DataTable Inscripciones(){return Query("SELECT i.Id,a.Titulo Actividad,e.nombres+' '+e.apellidos Estudiante,e.email Correo,i.FechaInscripcion,i.Estado FROM dbo.InscripcionActividad i JOIN dbo.ActividadAcademica a ON a.Id=i.ActividadId JOIN dbo.Estudiantes e ON e.Idestudiante=i.EstudianteId ORDER BY i.Id DESC");}
        public DataTable ObtenerActividad(int id){return Query("SELECT * FROM dbo.ActividadAcademica WHERE Id=@id",P("@id",SqlDbType.Int,id));}
        public void Guardar(int id,string titulo,string desc,int tipo,DateTime fi,DateTime ff,TimeSpan hi,TimeSpan hf,string modalidad,string lugar,int cupos,string estado){Exec("IF @id=0 INSERT dbo.ActividadAcademica(Titulo,Descripcion,TipoId,FechaInicio,FechaFin,HoraInicio,HoraFin,Modalidad,Lugar,Cupos,Estado) VALUES(@t,@d,@tipo,@fi,@ff,@hi,@hf,@m,@l,@cup,@e) ELSE UPDATE dbo.ActividadAcademica SET Titulo=@t,Descripcion=@d,TipoId=@tipo,FechaInicio=@fi,FechaFin=@ff,HoraInicio=@hi,HoraFin=@hf,Modalidad=@m,Lugar=@l,Cupos=@cup,Estado=@e WHERE Id=@id",P("@id",SqlDbType.Int,id),P("@t",SqlDbType.NVarChar,titulo),P("@d",SqlDbType.NVarChar,desc),P("@tipo",SqlDbType.Int,tipo),P("@fi",SqlDbType.Date,fi.Date),P("@ff",SqlDbType.Date,ff.Date),P("@hi",SqlDbType.Time,hi),P("@hf",SqlDbType.Time,hf),P("@m",SqlDbType.NVarChar,modalidad),P("@l",SqlDbType.NVarChar,lugar),P("@cup",SqlDbType.Int,cupos),P("@e",SqlDbType.NVarChar,estado));}
        public void CancelarActividad(int id){Exec("UPDATE dbo.ActividadAcademica SET Estado=N'Cancelada' WHERE Id=@id",P("@id",SqlDbType.Int,id));}
        public DataTable Cuenta(string correo){return Query("SELECT Nombre,PasswordHash,Salt,Iteraciones FROM dbo.UsuarioAcceso WHERE Correo=@e AND Activo=1",P("@e",SqlDbType.NVarChar,correo));}
        public bool Inscribir(int actividad,int estudiante){using(var c=new SqlConnection(cs)){c.Open();using(var tx=c.BeginTransaction(IsolationLevel.Serializable))using(var x=new SqlCommand("IF EXISTS(SELECT 1 FROM dbo.ActividadAcademica a WHERE a.Id=@a AND a.Estado<>N'Cancelada' AND a.FechaInicio>=CONVERT(date,GETDATE()) AND (SELECT COUNT(*) FROM dbo.InscripcionActividad i WHERE i.ActividadId=a.Id AND i.Estado=N'Confirmada')<a.Cupos) AND NOT EXISTS(SELECT 1 FROM dbo.InscripcionActividad WHERE ActividadId=@a AND EstudianteId=@e AND Estado=N'Confirmada') BEGIN IF EXISTS(SELECT 1 FROM dbo.InscripcionActividad WHERE ActividadId=@a AND EstudianteId=@e) UPDATE dbo.InscripcionActividad SET Estado=N'Confirmada',FechaInscripcion=SYSDATETIME() WHERE ActividadId=@a AND EstudianteId=@e; ELSE INSERT dbo.InscripcionActividad(ActividadId,EstudianteId) VALUES(@a,@e); END; SELECT @@ROWCOUNT",c,tx)){x.Parameters.Add("@a",SqlDbType.Int).Value=actividad;x.Parameters.Add("@e",SqlDbType.Int).Value=estudiante;bool ok=Convert.ToInt32(x.ExecuteScalar())>0;if(ok)tx.Commit();else tx.Rollback();return ok;}}}
        public void CancelarInscripcion(int id){Exec("UPDATE dbo.InscripcionActividad SET Estado=N'Cancelada' WHERE Id=@id",P("@id",SqlDbType.Int,id));}
    }
}
