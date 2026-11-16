using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using EncuentroAcademico.Entities;

namespace EncuentroAcademico.DAL
{
    public sealed class RegistroRepository
    {
        private readonly string _connectionString;

        public RegistroRepository()
        {
            ConnectionStringSettings settings = ConfigurationManager.ConnectionStrings["conexionDB"];
            if (settings == null) throw new ConfigurationErrorsException("Falta configurar la cadena conexionDB.");
            _connectionString = settings.ConnectionString;
        }

        public CatalogosDto ObtenerCatalogos()
        {
            return new CatalogosDto
            {
                Programas = ConsultarCatalogo("SELECT Idprograma AS id, nombre AS texto FROM Programas ORDER BY nombre"),
                Semestres = ConsultarCatalogo("SELECT Idsemestres AS id, descripcion AS texto FROM Semestre ORDER BY Idsemestres"),
                Jornadas = ConsultarCatalogo("SELECT Idjornada AS id, descripcion AS texto FROM Jornada ORDER BY Idjornada"),
                Temas = ConsultarCatalogo("SELECT Idtema AS id, descripcion AS texto FROM Tema ORDER BY descripcion"),
                Participaciones = ConsultarCatalogo("SELECT Idparticipacion AS id, descripcion AS texto FROM Tipo_de_participacion ORDER BY Idparticipacion")
            };
        }

        private DataTable ConsultarCatalogo(string sql)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            using (SqlDataAdapter adapter = new SqlDataAdapter(sql, connection))
            {
                DataTable table = new DataTable();
                adapter.Fill(table);
                return table;
            }
        }

        public DataTable Listar()
        {
            const string sql = @"SELECT r.numero, e.cedula, e.nombres + ' ' + e.apellidos AS estudiante,
                    e.genero, e.fecha_nacimiento, e.email, e.telefono, p.nombre AS programa,
                    s.descripcion AS semestre, tp.descripcion AS participacion, r.modalidad,
                    t.descripcion AS tema, j.descripcion AS jornada, r.fecha_inscripcion, r.comentarios
                FROM Registro r
                INNER JOIN Estudiantes e ON e.Idestudiante = r.Idestudiante
                INNER JOIN Programas p ON p.Idprograma = r.Idprograma
                INNER JOIN Semestre s ON s.Idsemestres = r.Idsemestres
                INNER JOIN Tipo_de_participacion tp ON tp.Idparticipacion = r.Idparticipacion
                INNER JOIN Tema t ON t.Idtema = r.Idtema
                INNER JOIN Jornada j ON j.Idjornada = r.Idjornada
                ORDER BY r.numero DESC;";
            using (SqlConnection connection = new SqlConnection(_connectionString))
            using (SqlDataAdapter adapter = new SqlDataAdapter(sql, connection))
            {
                DataTable table = new DataTable();
                adapter.Fill(table);
                return table;
            }
        }

        public RegistroFormularioDto Obtener(int numero)
        {
            const string sql = @"SELECT e.cedula, e.nombres, e.apellidos, e.email, e.telefono,
                    e.fecha_nacimiento, e.genero, r.Idprograma, r.Idsemestres, r.Idparticipacion,
                    r.Idtema, r.Idjornada, r.modalidad, r.fecha_inscripcion, r.comentarios
                FROM Registro r INNER JOIN Estudiantes e ON e.Idestudiante = r.Idestudiante
                WHERE r.numero = @numero;";
            using (SqlConnection connection = new SqlConnection(_connectionString))
            using (SqlCommand command = new SqlCommand(sql, connection))
            {
                command.Parameters.Add("@numero", SqlDbType.Int).Value = numero;
                connection.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (!reader.Read()) return null;
                    return new RegistroFormularioDto
                    {
                        Numero = numero, Cedula = reader["cedula"].ToString(),
                        Nombres = reader["nombres"].ToString(), Apellidos = reader["apellidos"].ToString(),
                        Correo = reader["email"].ToString(), Telefono = reader["telefono"].ToString(),
                        FechaNacimiento = reader["fecha_nacimiento"] == DBNull.Value ? DateTime.Today : Convert.ToDateTime(reader["fecha_nacimiento"]),
                        Genero = reader["genero"] == DBNull.Value ? "" : reader["genero"].ToString(),
                        ProgramaId = Convert.ToInt32(reader["Idprograma"]), SemestreId = Convert.ToInt32(reader["Idsemestres"]),
                        ParticipacionId = Convert.ToInt32(reader["Idparticipacion"]), TemaId = Convert.ToInt32(reader["Idtema"]),
                        JornadaId = Convert.ToInt32(reader["Idjornada"]), Modalidad = reader["modalidad"] == DBNull.Value ? "" : reader["modalidad"].ToString(),
                        FechaInscripcion = reader["fecha_inscripcion"] == DBNull.Value ? DateTime.Today : Convert.ToDateTime(reader["fecha_inscripcion"]),
                        Comentarios = reader["comentarios"] == DBNull.Value ? "" : reader["comentarios"].ToString()
                    };
                }
            }
        }

        public int Crear(RegistroFormularioDto item)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                connection.Open();
                using (SqlTransaction transaction = connection.BeginTransaction())
                {
                    try
                    {
                        int studentId = GuardarEstudiante(connection, transaction, item, null);
                        const string sql = @"INSERT INTO Registro
                            (Idestudiante, Idprograma, Idsemestres, Idparticipacion, Idtema, Idjornada, modalidad, fecha_inscripcion, comentarios)
                            VALUES (@est, @prog, @sem, @part, @tema, @jor, @mod, @fecha, @comentarios);
                            SELECT CAST(SCOPE_IDENTITY() AS INT);";
                        int id;
                        using (SqlCommand command = new SqlCommand(sql, connection, transaction))
                        {
                            AgregarParametrosRegistro(command, studentId, item);
                            id = Convert.ToInt32(command.ExecuteScalar());
                        }
                        transaction.Commit();
                        return id;
                    }
                    catch { transaction.Rollback(); throw; }
                }
            }
        }

        public void Actualizar(RegistroFormularioDto item)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                connection.Open();
                using (SqlTransaction transaction = connection.BeginTransaction())
                {
                    try
                    {
                        int studentId = ObtenerEstudianteId(connection, transaction, item.Numero);
                        const string duplicateSql = "SELECT COUNT(*) FROM Estudiantes WHERE cedula = @ced AND Idestudiante <> @id;";
                        using (SqlCommand duplicate = new SqlCommand(duplicateSql, connection, transaction))
                        {
                            duplicate.Parameters.Add("@ced", SqlDbType.VarChar, 20).Value = item.Cedula.Trim();
                            duplicate.Parameters.Add("@id", SqlDbType.Int).Value = studentId;
                            if (Convert.ToInt32(duplicate.ExecuteScalar()) > 0)
                                throw new InvalidOperationException("Ya existe otro estudiante con esa cédula.");
                        }
                        GuardarEstudiante(connection, transaction, item, studentId);
                        const string sql = @"UPDATE Registro SET Idprograma=@prog, Idsemestres=@sem, Idparticipacion=@part,
                                Idtema=@tema, Idjornada=@jor, modalidad=@mod, fecha_inscripcion=@fecha, comentarios=@comentarios
                            WHERE numero=@numero;";
                        using (SqlCommand command = new SqlCommand(sql, connection, transaction))
                        {
                            AgregarParametrosRegistro(command, studentId, item, false);
                            command.Parameters.Add("@numero", SqlDbType.Int).Value = item.Numero;
                            if (command.ExecuteNonQuery() == 0) throw new InvalidOperationException("El registro ya no existe.");
                        }
                        transaction.Commit();
                    }
                    catch { transaction.Rollback(); throw; }
                }
            }
        }

        public void Eliminar(int numero)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                connection.Open();
                using (SqlTransaction transaction = connection.BeginTransaction())
                {
                    try
                    {
                        int studentId = ObtenerEstudianteId(connection, transaction, numero);
                        using (SqlCommand command = new SqlCommand("DELETE FROM Registro WHERE numero=@numero;", connection, transaction))
                        {
                            command.Parameters.Add("@numero", SqlDbType.Int).Value = numero;
                            command.ExecuteNonQuery();
                        }
                        using (SqlCommand command = new SqlCommand(@"DELETE FROM Estudiantes WHERE Idestudiante=@id
                            AND NOT EXISTS (SELECT 1 FROM Registro WHERE Idestudiante=@id);", connection, transaction))
                        {
                            command.Parameters.Add("@id", SqlDbType.Int).Value = studentId;
                            command.ExecuteNonQuery();
                        }
                        transaction.Commit();
                    }
                    catch { transaction.Rollback(); throw; }
                }
            }
        }

        private int GuardarEstudiante(SqlConnection connection, SqlTransaction transaction, RegistroFormularioDto item, int? studentId)
        {
            if (studentId.HasValue)
            {
                const string update = @"UPDATE Estudiantes SET cedula=@ced, nombres=@nom, apellidos=@ape,
                    email=@email, telefono=@tel, fecha_nacimiento=@nacimiento, genero=@genero WHERE Idestudiante=@id;";
                using (SqlCommand command = new SqlCommand(update, connection, transaction))
                {
                    AgregarParametrosEstudiante(command, item);
                    command.Parameters.Add("@id", SqlDbType.Int).Value = studentId.Value;
                    command.ExecuteNonQuery();
                }
                return studentId.Value;
            }

            const string find = "SELECT Idestudiante FROM Estudiantes WHERE cedula=@ced;";
            object existing;
            using (SqlCommand command = new SqlCommand(find, connection, transaction))
            {
                command.Parameters.Add("@ced", SqlDbType.VarChar, 20).Value = item.Cedula.Trim();
                existing = command.ExecuteScalar();
            }
            if (existing != null) return Convert.ToInt32(existing);

            const string insert = @"INSERT INTO Estudiantes (cedula,nombres,apellidos,email,telefono,fecha_nacimiento,genero)
                VALUES (@ced,@nom,@ape,@email,@tel,@nacimiento,@genero); SELECT CAST(SCOPE_IDENTITY() AS INT);";
            using (SqlCommand command = new SqlCommand(insert, connection, transaction))
            {
                AgregarParametrosEstudiante(command, item);
                return Convert.ToInt32(command.ExecuteScalar());
            }
        }

        private int ObtenerEstudianteId(SqlConnection connection, SqlTransaction transaction, int numero)
        {
            using (SqlCommand command = new SqlCommand("SELECT Idestudiante FROM Registro WHERE numero=@numero;", connection, transaction))
            {
                command.Parameters.Add("@numero", SqlDbType.Int).Value = numero;
                object result = command.ExecuteScalar();
                if (result == null) throw new InvalidOperationException("El registro ya no existe.");
                return Convert.ToInt32(result);
            }
        }

        private static void AgregarParametrosEstudiante(SqlCommand command, RegistroFormularioDto item)
        {
            command.Parameters.Add("@ced", SqlDbType.VarChar, 20).Value = item.Cedula.Trim();
            command.Parameters.Add("@nom", SqlDbType.VarChar, 100).Value = item.Nombres.Trim();
            command.Parameters.Add("@ape", SqlDbType.VarChar, 100).Value = item.Apellidos.Trim();
            command.Parameters.Add("@email", SqlDbType.VarChar, 150).Value = item.Correo.Trim();
            command.Parameters.Add("@tel", SqlDbType.VarChar, 20).Value = item.Telefono.Trim();
            command.Parameters.Add("@nacimiento", SqlDbType.Date).Value = item.FechaNacimiento.Date;
            command.Parameters.Add("@genero", SqlDbType.VarChar, 30).Value = item.Genero;
        }

        private static void AgregarParametrosRegistro(SqlCommand command, int studentId, RegistroFormularioDto item, bool incluirEstudiante = true)
        {
            if (incluirEstudiante) command.Parameters.Add("@est", SqlDbType.Int).Value = studentId;
            command.Parameters.Add("@prog", SqlDbType.Int).Value = item.ProgramaId;
            command.Parameters.Add("@sem", SqlDbType.Int).Value = item.SemestreId;
            command.Parameters.Add("@part", SqlDbType.Int).Value = item.ParticipacionId;
            command.Parameters.Add("@tema", SqlDbType.Int).Value = item.TemaId;
            command.Parameters.Add("@jor", SqlDbType.Int).Value = item.JornadaId;
            command.Parameters.Add("@mod", SqlDbType.VarChar, 20).Value = item.Modalidad;
            command.Parameters.Add("@fecha", SqlDbType.Date).Value = item.FechaInscripcion.Date;
            command.Parameters.Add("@comentarios", SqlDbType.VarChar, 500).Value = string.IsNullOrWhiteSpace(item.Comentarios) ? (object)DBNull.Value : item.Comentarios.Trim();
        }
    }
}


