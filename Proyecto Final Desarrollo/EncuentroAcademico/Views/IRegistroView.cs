using System.Data;
using EncuentroAcademico.Entities;

namespace EncuentroAcademico.Views
{
    public interface IRegistroView
    {
        void MostrarCatalogos(CatalogosDto catalogos);
        void MostrarRegistros(DataTable registros);
        void CargarFormulario(RegistroFormularioDto registro);
        void MostrarMensaje(string tipo, string mensaje);
    }
}
