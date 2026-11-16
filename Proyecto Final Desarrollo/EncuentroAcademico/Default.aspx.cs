using System;
using System.Data;
using System.Globalization;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EncuentroAcademico.Entities;
using EncuentroAcademico.Presenters;
using EncuentroAcademico.Views;

namespace EncuentroAcademico
{
    public partial class _Default : Page, IRegistroView
    {
        private RegistroPresenter _presenter;
        private int? NumeroSeleccionado
        {
            get { return ViewState["numero"] == null ? (int?)null : Convert.ToInt32(ViewState["numero"]); }
            set { ViewState["numero"] = value; }
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            _presenter = new RegistroPresenter(this);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                calFecha.SelectedDate = DateTime.Today;
                calFecha.VisibleDate = DateTime.Today;
                _presenter.CargarInicial();
            }
        }

        public void MostrarCatalogos(CatalogosDto catalogos)
        {
            EnlazarLista(ddlPrograma, catalogos.Programas, "Seleccione un programa");
            EnlazarLista(ddlSemestre, catalogos.Semestres, "Seleccione");
            EnlazarLista(ddlJornada, catalogos.Jornadas, "Seleccione");
            EnlazarLista(ddlTema, catalogos.Temas, "Seleccione un tema");
            EnlazarLista(rblParticipacion, catalogos.Participaciones, null);
        }

        private static void EnlazarLista(ListControl control, DataTable datos, string textoInicial)
        {
            control.DataSource = datos;
            control.DataTextField = "texto";
            control.DataValueField = "id";
            control.DataBind();
            if (textoInicial != null) control.Items.Insert(0, new ListItem(textoInicial, ""));
        }

        public void MostrarRegistros(DataTable registros)
        {
            gvRegistros.DataSource = registros;
            gvRegistros.DataBind();
        }

        public void CargarFormulario(RegistroFormularioDto item)
        {
            txtCedula.Text = item.Cedula;
            txtNombres.Text = item.Nombres;
            txtApellidos.Text = item.Apellidos;
            txtCorreo.Text = item.Correo;
            txtTelefono.Text = item.Telefono;
            txtFechaNacimiento.Text = item.FechaNacimiento.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);
            Seleccionar(ddlGenero, item.Genero);
            Seleccionar(ddlPrograma, item.ProgramaId.ToString(CultureInfo.InvariantCulture));
            Seleccionar(ddlSemestre, item.SemestreId.ToString(CultureInfo.InvariantCulture));
            Seleccionar(rblParticipacion, item.ParticipacionId.ToString(CultureInfo.InvariantCulture));
            Seleccionar(ddlTema, item.TemaId.ToString(CultureInfo.InvariantCulture));
            Seleccionar(ddlJornada, item.JornadaId.ToString(CultureInfo.InvariantCulture));
            Seleccionar(rblModalidad, item.Modalidad);
            txtComentarios.Text = item.Comentarios;
            calFecha.SelectedDate = item.FechaInscripcion;
            calFecha.VisibleDate = item.FechaInscripcion;
            chkAcepta.Checked = true;
            NumeroSeleccionado = item.Numero;
            ModoEdicion(true);
            pnlResult.Visible = false;
        }

        private static void Seleccionar(ListControl control, string valor)
        {
            ListItem item = control.Items.FindByValue(valor);
            if (item != null) { control.ClearSelection(); item.Selected = true; }
        }

        public void MostrarMensaje(string tipo, string mensaje)
        {
            lblMensaje.Text = "<div class=\"alert alert-" + HttpUtility.HtmlAttributeEncode(tipo) + "\">" +
                HttpUtility.HtmlEncode(mensaje) + "</div>";
            pnlResult.Visible = true;
        }

        protected void gvRegistros_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (gvRegistros.SelectedDataKey == null) return;
            int numero = Convert.ToInt32(gvRegistros.SelectedDataKey.Value, CultureInfo.InvariantCulture);
            if (!_presenter.Seleccionar(numero)) _presenter.ActualizarListado();
        }

        protected void btnCrear_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();
            MostrarMensaje("info", "Formulario listo para crear un nuevo registro.");
        }

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            Page.Validate("vg1");
            if (!Page.IsValid) { pnlResult.Visible = false; return; }
            RegistroFormularioDto item = LeerFormulario();
            if (_presenter.Crear(item)) LimpiarFormulario(false);
        }

        protected void btnActualizar_Click(object sender, EventArgs e)
        {
            Page.Validate("vg1");
            if (!Page.IsValid) { pnlResult.Visible = false; return; }
            if (!NumeroSeleccionado.HasValue)
            {
                MostrarMensaje("warning", "Selecciona primero un registro de la tabla.");
                return;
            }
            RegistroFormularioDto item = LeerFormulario();
            item.Numero = NumeroSeleccionado.Value;
            if (_presenter.Actualizar(item)) LimpiarFormulario(false);
        }

        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            if (!NumeroSeleccionado.HasValue)
            {
                MostrarMensaje("warning", "Selecciona primero un registro de la tabla.");
                return;
            }
            if (_presenter.Eliminar(NumeroSeleccionado.Value)) LimpiarFormulario(false);
        }

        private RegistroFormularioDto LeerFormulario()
        {
            DateTime nacimiento;
            if (!DateTime.TryParseExact(txtFechaNacimiento.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out nacimiento))
                throw new InvalidOperationException("La fecha de nacimiento no es válida.");
            int numero = 0;
            return new RegistroFormularioDto
            {
                Numero = numero,
                Cedula = txtCedula.Text.Trim(), Nombres = txtNombres.Text.Trim(), Apellidos = txtApellidos.Text.Trim(),
                Correo = txtCorreo.Text.Trim(), Telefono = txtTelefono.Text.Trim(), FechaNacimiento = nacimiento,
                Genero = ddlGenero.SelectedValue, ProgramaId = LeerId(ddlPrograma), SemestreId = LeerId(ddlSemestre),
                ParticipacionId = LeerId(rblParticipacion), TemaId = LeerId(ddlTema), JornadaId = LeerId(ddlJornada),
                Modalidad = rblModalidad.SelectedValue, FechaInscripcion = calFecha.SelectedDate == DateTime.MinValue ? DateTime.Today : calFecha.SelectedDate,
                Comentarios = txtComentarios.Text.Trim()
            };
        }

        private static int LeerId(ListControl control)
        {
            int value;
            return int.TryParse(control.SelectedValue, NumberStyles.Integer, CultureInfo.InvariantCulture, out value) ? value : 0;
        }

        private void LimpiarFormulario(bool actualizarListado = true)
        {
            txtCedula.Text = txtNombres.Text = txtApellidos.Text = txtCorreo.Text = txtTelefono.Text = "";
            txtFechaNacimiento.Text = "";
            ddlGenero.SelectedIndex = 0;
            ddlPrograma.SelectedIndex = 0;
            ddlSemestre.SelectedIndex = 0;
            ddlJornada.SelectedIndex = 0;
            ddlTema.SelectedIndex = 0;
            rblParticipacion.ClearSelection();
            rblModalidad.ClearSelection();
            calFecha.SelectedDate = DateTime.Today;
            calFecha.VisibleDate = DateTime.Today;
            txtComentarios.Text = "";
            chkAcepta.Checked = false;
            NumeroSeleccionado = null;
            gvRegistros.SelectedIndex = -1;
            ModoEdicion(false);
            if (actualizarListado) _presenter.ActualizarListado();
        }

        private void ModoEdicion(bool editando)
        {
            btnActualizar.Enabled = editando;
            btnEliminar.Enabled = editando;
            lblEditando.Visible = editando;
            lblEditando.Text = editando ? "Registro seleccionado para edición. Guarde los cambios o elimínelo." : "";
        }

        protected void cvFechaNacimiento_ServerValidate(object source, ServerValidateEventArgs args)
        {
            DateTime nacimiento;
            if (!DateTime.TryParseExact(args.Value, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out nacimiento))
            { args.IsValid = false; return; }
            int edad = DateTime.Today.Year - nacimiento.Year;
            if (nacimiento.Date > DateTime.Today.AddYears(-edad)) edad--;
            args.IsValid = edad >= 15 && edad <= 80;
        }

        protected void cvAcepta_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = chkAcepta.Checked;
        }
    }
}


