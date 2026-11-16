using System;
using System.Diagnostics;
using EncuentroAcademico.BLL;
using EncuentroAcademico.Entities;
using EncuentroAcademico.Views;

namespace EncuentroAcademico.Presenters
{
    public sealed class RegistroPresenter
    {
        private readonly IRegistroView _view;
        private readonly RegistroService _service;
        public RegistroPresenter(IRegistroView view) { _view = view; _service = new RegistroService(); }

        public void CargarInicial()
        {
            try
            {
                _view.MostrarCatalogos(_service.ObtenerCatalogos());
                _view.MostrarRegistros(_service.Listar());
            }
            catch (Exception ex)
            {
                Trace.TraceError("Error al cargar registros académicos: {0}", ex);
                _view.MostrarMensaje("danger", "No fue posible cargar la información. Verifica la conexión y la base de datos.");
            }
        }
        public void ActualizarListado()
        {
            try { _view.MostrarRegistros(_service.Listar()); }
            catch (Exception ex) { Trace.TraceError("Error al actualizar el listado: {0}", ex); _view.MostrarMensaje("danger", "No fue posible actualizar el listado."); }
        }
        public bool Seleccionar(int numero)
        {
            try
            {
                RegistroFormularioDto item = _service.Obtener(numero);
                if (item == null) { _view.MostrarMensaje("warning", "El registro ya no existe. Actualiza el listado."); return false; }
                _view.CargarFormulario(item);
                return true;
            }
            catch (Exception ex) { Trace.TraceError("Error al consultar un registro: {0}", ex); _view.MostrarMensaje("danger", "No fue posible consultar el registro."); return false; }
        }
        public bool Crear(RegistroFormularioDto item)
        {
            try
            {
                int numero = _service.Crear(item);
                ActualizarListado();
                _view.MostrarMensaje("success", "Registro N° " + numero + " guardado correctamente.");
                return true;
            }
            catch (ArgumentException ex) { _view.MostrarMensaje("warning", ex.Message); return false; }
            catch (Exception ex) { Trace.TraceError("Error al crear un registro: {0}", ex); _view.MostrarMensaje("danger", "No se pudo guardar el registro. Revisa los datos e intenta de nuevo."); return false; }
        }
        public bool Actualizar(RegistroFormularioDto item)
        {
            try
            {
                _service.Actualizar(item);
                ActualizarListado();
                _view.MostrarMensaje("success", "Registro N° " + item.Numero + " actualizado correctamente.");
                return true;
            }
            catch (ArgumentException ex) { _view.MostrarMensaje("warning", ex.Message); return false; }
            catch (InvalidOperationException ex) { _view.MostrarMensaje("warning", ex.Message); return false; }
            catch (Exception ex) { Trace.TraceError("Error al actualizar un registro: {0}", ex); _view.MostrarMensaje("danger", "No se pudo actualizar el registro. Revisa los datos e intenta de nuevo."); return false; }
        }
        public bool Eliminar(int numero)
        {
            try
            {
                _service.Eliminar(numero);
                ActualizarListado();
                _view.MostrarMensaje("success", "Registro N° " + numero + " eliminado correctamente.");
                return true;
            }
            catch (ArgumentException ex) { _view.MostrarMensaje("warning", ex.Message); return false; }
            catch (InvalidOperationException ex) { _view.MostrarMensaje("warning", ex.Message); return false; }
            catch (Exception ex) { Trace.TraceError("Error al eliminar un registro: {0}", ex); _view.MostrarMensaje("danger", "No se pudo eliminar el registro."); return false; }
        }
    }
}
