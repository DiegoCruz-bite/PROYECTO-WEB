<%@ Page Title="Encuentro Académico" Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="EncuentroAcademico._Default" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Encuentro Académico</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        :root {
            --primario: #0f766e;
            --primario-oscuro: #134e4a;
            --acento: #f59e0b;
            --fondo: #f0fdfa;
            --borde: #ccebe6;
            --texto: #1f2937;
        }

        body { background: var(--fondo); font-family: 'Poppins', sans-serif; color: var(--texto); }

        /* Encabezado */
        .encabezado {
            background: linear-gradient(135deg, var(--primario-oscuro), var(--primario));
            color: #fff; padding: 36px 0 70px; text-align: center;
        }
        .encabezado .etiqueta {
            display: inline-block; background: var(--acento); color: var(--primario-oscuro);
            font-weight: 600; font-size: .75rem; letter-spacing: .08em; text-transform: uppercase;
            padding: 4px 12px; border-radius: 999px; margin-bottom: 10px;
        }
        .encabezado h1 { font-weight: 700; font-size: 2rem; margin: 0; }
        .encabezado p { opacity: .85; margin: 6px 0 0; }

        .contenido { margin-top: -45px; }
        .tarjeta { background: #fff; border: 1px solid var(--borde); border-radius: 14px; box-shadow: 0 8px 24px rgba(15, 118, 110, .08); }

        /* Secciones del formulario */
        .seccion { padding: 22px 26px; border-bottom: 1px solid var(--borde); }
        .seccion:last-child { border-bottom: 0; }
        .seccion-titulo { display: flex; align-items: center; gap: 10px; font-weight: 600; color: var(--primario-oscuro); margin-bottom: 16px; }
        .seccion-numero {
            width: 28px; height: 28px; border-radius: 50%; background: var(--primario); color: #fff;
            display: inline-flex; align-items: center; justify-content: center; font-size: .85rem;
        }

        .campo-label { font-weight: 500; font-size: .9rem; margin-bottom: 4px; display: block; }
        .form-control { border-radius: 8px; border-color: #b9ded8; }
        .form-control:focus { border-color: var(--primario); box-shadow: 0 0 0 .2rem rgba(15, 118, 110, .15); }
        .error { color: #b91c1c; font-size: .82rem; }

        .form-control { height: 42px; }
        textarea.form-control { height: auto; }

        /* Opciones (radio) como botones tipo "píldora" */
        .opciones td { padding: 0 8px 0 0; }
        .opciones input { position: absolute; opacity: 0; }
        .opciones label {
            display: inline-block; margin: 0; padding: 8px 18px; border: 1px solid #b9ded8; border-radius: 999px;
            background: #fff; cursor: pointer; font-size: .9rem; transition: all .15s;
        }
        .opciones label:hover { border-color: var(--primario); }
        .opciones input:checked + label { background: var(--primario); border-color: var(--primario); color: #fff; }
        .opciones input:focus + label { box-shadow: 0 0 0 .2rem rgba(15, 118, 110, .15); }

        /* Calendario: mismo ancho que la columna y celdas aireadas */
        .calendario { width: 100%; border: 1px solid #b9ded8 !important; border-radius: 10px; border-collapse: separate; overflow: hidden; background: #fff; font-size: .85rem; }
        .calendario td, .calendario th { padding: 6px 0; text-align: center; border: 0 !important; }
        .calendario > tbody > tr:first-child > td { background: var(--primario) !important; padding: 0 !important; }
        .cal-titulo { background: var(--primario) !important; color: #fff; font-weight: 600; }
        .cal-titulo td { padding: 10px 0 !important; }
        .cal-titulo a, .cal-titulo td { color: #fff !important; }
        .cal-dias { color: #6b7f7c; font-weight: 500; font-size: .75rem; text-transform: uppercase; }
        .cal-otro a { color: #b6c8c5 !important; }
        .cal-seleccion { background: var(--acento) !important; border-radius: 8px; font-weight: 600; }
        .cal-seleccion a { color: var(--primario-oscuro) !important; }
        .cal-hoy a { font-weight: 700; color: var(--primario); }
        .calendario a { color: inherit; text-decoration: none; display: block; }

        /* Mensajes con la misma paleta (reemplazan los colores por defecto de Bootstrap) */
        .alert { border: 0; border-left: 4px solid; border-radius: 8px; font-size: .92rem; }
        .alert-success { background: #ecfdf5; border-color: var(--primario); color: var(--primario-oscuro); }
        .alert-info { background: #f0fdfa; border-color: #14b8a6; color: var(--primario-oscuro); }
        .alert-warning { background: #fffbeb; border-color: var(--acento); color: #78350f; }
        .alert-danger { background: #fef2f2; border-color: #b91c1c; color: #7f1d1d; }
        .alert-danger ul { margin: 6px 0 0; padding-left: 18px; }
        #pnlResult .card { border: 1px solid var(--borde); border-radius: 12px; }
        #pnlResult .text-success { color: var(--primario) !important; font-weight: 700; }
        #pnlResult .alert-light { background: var(--fondo); border-color: var(--acento); color: var(--texto); text-align: left; }

        /* Botones */
        .barra-botones { background: #f8fffd; padding: 18px 26px; border-top: 1px solid var(--borde); border-radius: 0 0 14px 14px; }
        .btn { border-radius: 8px; font-weight: 600; letter-spacing: .03em; padding: 8px 18px; min-width: 130px; }
        .btn-crear { background: #fff; color: var(--primario); border: 2px solid var(--primario); }
        .btn-crear:hover { background: var(--primario); color: #fff; }
        .btn-registrar { background: var(--primario); color: #fff; border: 2px solid var(--primario); }
        .btn-registrar:hover { background: var(--primario-oscuro); color: #fff; }
        .btn-actualizar { background: var(--acento); color: var(--primario-oscuro); border: 2px solid var(--acento); }
        .btn-actualizar:hover { background: #d97706; color: #fff; }
        .btn-eliminar { background: #fff; color: #b91c1c; border: 2px solid #b91c1c; }
        .btn-eliminar:hover { background: #b91c1c; color: #fff; }
        .btn:disabled { opacity: .45; }

        .aviso-edicion { background: #fffbeb; border-left: 4px solid var(--acento); padding: 10px 14px; border-radius: 6px; display: block; margin-bottom: 0; }

        /* Tabla de registros */
        .tabla-registros th { background: var(--primario-oscuro); color: #fff; font-weight: 500; font-size: .82rem; white-space: nowrap; }
        .tabla-registros td { font-size: .84rem; vertical-align: middle; }
        .tabla-registros a { color: var(--primario); font-weight: 600; }
        .fila-seleccionada td { background: #fef3c7 !important; }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <header class="encabezado">
        <div class="container">
            <span class="etiqueta">Inscripciones 2026</span>
            <h1>Encuentro Académico</h1>
            <p>Registro de estudiantes — ASP.NET Web Forms, C# y SQL Server</p>
        </div>
    </header>

    <main class="container contenido mb-5">
        <div class="tarjeta">
            <div class="seccion pb-0" style="border-bottom:0">
                <asp:Label ID="lblErrorConexion" runat="server" Visible="false" CssClass="alert alert-warning d-block" />
                <asp:ValidationSummary ID="vsSummary" runat="server" CssClass="alert alert-danger"
                    ValidationGroup="vg1" HeaderText="Revise los siguientes campos:" />
                <asp:Label ID="lblEditando" runat="server" Visible="false" CssClass="aviso-edicion" />
            </div>

            <!-- 1. Datos personales -->
            <section class="seccion">
                <div class="seccion-titulo"><span class="seccion-numero">1</span> Datos personales</div>
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <asp:Label ID="lblCedula" runat="server" AssociatedControlID="txtCedula" Text="Cédula *" CssClass="campo-label" />
                        <asp:TextBox ID="txtCedula" runat="server" CssClass="form-control" placeholder="Número de cédula" MaxLength="20" />
                        <asp:RequiredFieldValidator ID="rfvCedula" runat="server" ControlToValidate="txtCedula"
                            ErrorMessage="Cédula requerida." Display="Dynamic" ValidationGroup="vg1" CssClass="error" />
                        <asp:RegularExpressionValidator ID="revCedula" runat="server" ControlToValidate="txtCedula"
                            ValidationExpression="^[0-9]{6,10}$"
                            ErrorMessage="La cédula debe tener solo números (entre 6 y 10 dígitos)." Display="Dynamic" ValidationGroup="vg1" CssClass="error" />
                    </div>
                    <div class="col-md-4 mb-3">
                        <asp:Label ID="lblNombres" runat="server" AssociatedControlID="txtNombres" Text="Nombres *" CssClass="campo-label" />
                        <asp:TextBox ID="txtNombres" runat="server" CssClass="form-control" placeholder="Escriba sus nombres" MaxLength="100" />
                        <asp:RequiredFieldValidator ID="rfvNombres" runat="server" ControlToValidate="txtNombres"
                            ErrorMessage="Nombres requeridos." Display="Dynamic" ValidationGroup="vg1" CssClass="error" />
                    </div>
                    <div class="col-md-4 mb-3">
                        <asp:Label ID="lblApellidos" runat="server" AssociatedControlID="txtApellidos" Text="Apellidos *" CssClass="campo-label" />
                        <asp:TextBox ID="txtApellidos" runat="server" CssClass="form-control" placeholder="Escriba sus apellidos" MaxLength="100" />
                        <asp:RequiredFieldValidator ID="rfvApellidos" runat="server" ControlToValidate="txtApellidos"
                            ErrorMessage="Apellidos requeridos." Display="Dynamic" ValidationGroup="vg1" CssClass="error" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <asp:Label ID="lblFechaNacimiento" runat="server" AssociatedControlID="txtFechaNacimiento" Text="Fecha de nacimiento *" CssClass="campo-label" />
                        <asp:TextBox ID="txtFechaNacimiento" runat="server" CssClass="form-control" TextMode="Date" />
                        <asp:RequiredFieldValidator ID="rfvFechaNacimiento" runat="server" ControlToValidate="txtFechaNacimiento"
                            ErrorMessage="Fecha de nacimiento requerida." Display="Dynamic" ValidationGroup="vg1" CssClass="error" />
                        <asp:CustomValidator ID="cvFechaNacimiento" runat="server" ControlToValidate="txtFechaNacimiento"
                            ClientValidationFunction="validateEdad" OnServerValidate="cvFechaNacimiento_ServerValidate"
                            ErrorMessage="La edad debe estar entre 15 y 80 años." Display="Dynamic" ValidationGroup="vg1" CssClass="error" />
                    </div>
                    <div class="col-md-4 mb-3">
                        <asp:Label ID="lblGenero" runat="server" AssociatedControlID="ddlGenero" Text="Género *" CssClass="campo-label" />
                        <asp:DropDownList ID="ddlGenero" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">Seleccione</asp:ListItem>
                            <asp:ListItem>Femenino</asp:ListItem>
                            <asp:ListItem>Masculino</asp:ListItem>
                            <asp:ListItem>No binario</asp:ListItem>
                            <asp:ListItem>Prefiero no decirlo</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvGenero" runat="server" ControlToValidate="ddlGenero" InitialValue=""
                            ErrorMessage="Seleccione un género." Display="Dynamic" ValidationGroup="vg1" CssClass="error" />
                    </div>
                </div>
            </section>

            <!-- 2. Contacto -->
            <section class="seccion">
                <div class="seccion-titulo"><span class="seccion-numero">2</span> Contacto</div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <asp:Label ID="lblCorreo" runat="server" AssociatedControlID="txtCorreo" Text="Correo electrónico *" CssClass="campo-label" />
                        <asp:TextBox ID="txtCorreo" runat="server" CssClass="form-control" placeholder="ejemplo@correo.com" MaxLength="150" />
                        <asp:RequiredFieldValidator ID="rfvCorreo" runat="server" ControlToValidate="txtCorreo"
                            ErrorMessage="Correo requerido." Display="Dynamic" ValidationGroup="vg1" CssClass="error" />
                        <asp:RegularExpressionValidator ID="revCorreo" runat="server" ControlToValidate="txtCorreo"
                            ValidationExpression="^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}$"
                            ErrorMessage="Formato de correo inválido." Display="Dynamic" ValidationGroup="vg1" CssClass="error" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <asp:Label ID="lblTelefono" runat="server" AssociatedControlID="txtTelefono" Text="Teléfono *" CssClass="campo-label" />
                        <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" placeholder="3000000000" MaxLength="20" />
                        <asp:RequiredFieldValidator ID="rfvTelefono" runat="server" ControlToValidate="txtTelefono"
                            ErrorMessage="Teléfono requerido." Display="Dynamic" ValidationGroup="vg1" CssClass="error" />
                        <asp:RegularExpressionValidator ID="revTelefono" runat="server" ControlToValidate="txtTelefono"
                            ValidationExpression="^[0-9\s\-\+\(\)]{7,20}$"
                            ErrorMessage="Formato de teléfono inválido." Display="Dynamic" ValidationGroup="vg1" CssClass="error" />
                    </div>
                </div>
            </section>

            <!-- 3. Información académica -->
            <section class="seccion">
                <div class="seccion-titulo"><span class="seccion-numero">3</span> Información académica</div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <asp:Label ID="lblPrograma" runat="server" AssociatedControlID="ddlPrograma" Text="Programa académico *" CssClass="campo-label" />
                        <asp:DropDownList ID="ddlPrograma" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvPrograma" runat="server" ControlToValidate="ddlPrograma" InitialValue=""
                            ErrorMessage="Seleccione un programa." Display="Dynamic" ValidationGroup="vg1" CssClass="error" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <asp:Label ID="lblSemestre" runat="server" AssociatedControlID="ddlSemestre" Text="Semestre *" CssClass="campo-label" />
                        <asp:DropDownList ID="ddlSemestre" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvSemestre" runat="server" ControlToValidate="ddlSemestre" InitialValue=""
                            ErrorMessage="Seleccione un semestre." Display="Dynamic" ValidationGroup="vg1" CssClass="error" />
                    </div>
                </div>
            </section>

            <!-- 4. Participación en el encuentro -->
            <section class="seccion">
                <div class="seccion-titulo"><span class="seccion-numero">4</span> Participación en el encuentro</div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <asp:Label ID="lblTema" runat="server" AssociatedControlID="ddlTema" Text="Tema de interés *" CssClass="campo-label" />
                        <asp:DropDownList ID="ddlTema" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvTema" runat="server" ControlToValidate="ddlTema" InitialValue=""
                            ErrorMessage="Seleccione un tema de interés." Display="Dynamic" ValidationGroup="vg1" CssClass="error" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <asp:Label ID="lblJornada" runat="server" AssociatedControlID="ddlJornada" Text="Jornada preferida *" CssClass="campo-label" />
                        <asp:DropDownList ID="ddlJornada" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvJornada" runat="server" ControlToValidate="ddlJornada" InitialValue=""
                            ErrorMessage="Seleccione una jornada." Display="Dynamic" ValidationGroup="vg1" CssClass="error" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <asp:Label ID="lblParticipacion" runat="server" Text="Tipo de participación *" CssClass="campo-label" />
                        <asp:RadioButtonList ID="rblParticipacion" runat="server" RepeatDirection="Horizontal" CssClass="opciones" />
                        <asp:RequiredFieldValidator ID="rfvParticipacion" runat="server" ControlToValidate="rblParticipacion"
                            ErrorMessage="Seleccione una participación." Display="Dynamic" ValidationGroup="vg1" CssClass="error" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <asp:Label ID="lblModalidad" runat="server" Text="Modalidad *" CssClass="campo-label" />
                        <asp:RadioButtonList ID="rblModalidad" runat="server" RepeatDirection="Horizontal" CssClass="opciones">
                            <asp:ListItem>Presencial</asp:ListItem>
                            <asp:ListItem>Virtual</asp:ListItem>
                        </asp:RadioButtonList>
                        <asp:RequiredFieldValidator ID="rfvModalidad" runat="server" ControlToValidate="rblModalidad"
                            ErrorMessage="Seleccione la modalidad." Display="Dynamic" ValidationGroup="vg1" CssClass="error" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <asp:Label ID="lblFecha" runat="server" Text="Fecha de inscripción *" CssClass="campo-label" />
                        <asp:Calendar ID="calFecha" runat="server" CssClass="calendario" BorderStyle="None"
                            TitleStyle-CssClass="cal-titulo" SelectedDayStyle-CssClass="cal-seleccion"
                            TodayDayStyle-CssClass="cal-hoy" DayHeaderStyle-CssClass="cal-dias"
                            OtherMonthDayStyle-CssClass="cal-otro" NextPrevFormat="ShortMonth" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <asp:Label ID="lblComentarios" runat="server" AssociatedControlID="txtComentarios" Text="Comentarios" CssClass="campo-label" />
                        <asp:TextBox ID="txtComentarios" runat="server" TextMode="MultiLine" Rows="11" CssClass="form-control" MaxLength="500"
                            placeholder="¿Algo que debamos saber? (opcional)" />
                    </div>
                </div>

                <div class="form-check mt-1">
                    <asp:CheckBox ID="chkAcepta" runat="server" />
                    <asp:Label ID="lblAcepta" runat="server" AssociatedControlID="chkAcepta"
                        Text="Acepto el tratamiento de mis datos para fines académicos." />
                    <asp:CustomValidator ID="cvAcepta" runat="server" ErrorMessage="Debe aceptar el tratamiento de datos."
                        ClientValidationFunction="validateAcepta" OnServerValidate="cvAcepta_ServerValidate"
                        Display="Dynamic" ValidationGroup="vg1" CssClass="error" />
                </div>
            </section>

            <!-- Botones -->
            <div class="barra-botones">
                <asp:Button ID="btnCrear" runat="server" Text="CREAR" CssClass="btn btn-crear mr-2 mb-2"
                    OnClick="btnCrear_Click" CausesValidation="false" />
                <asp:Button ID="btnRegistrar" runat="server" Text="REGISTRAR" CssClass="btn btn-registrar mr-2 mb-2"
                    OnClick="btnRegistrar_Click" ValidationGroup="vg1" />
                <asp:Button ID="btnActualizar" runat="server" Text="ACTUALIZAR" CssClass="btn btn-actualizar mr-2 mb-2"
                    OnClick="btnActualizar_Click" ValidationGroup="vg1" Enabled="false" />
                <asp:Button ID="btnEliminar" runat="server" Text="ELIMINAR" CssClass="btn btn-eliminar mb-2"
                    OnClick="btnEliminar_Click" CausesValidation="false" Enabled="false"
                    OnClientClick="return confirm('¿Seguro que desea eliminar este registro?');" />
                <div class="text-muted small">
                    Para actualizar o eliminar, pulse <strong>Seleccionar</strong> en un registro de la tabla de abajo.
                </div>

                <!-- Resultado -->
                <asp:Panel ID="pnlResult" runat="server" Visible="false" CssClass="mt-3">
                    <asp:Label ID="lblMensaje" runat="server" EnableViewState="false" />
                </asp:Panel>
            </div>
        </div>

        <!-- Registros guardados en SQL Server -->
        <div class="tarjeta mt-4">
            <div class="seccion">
                <div class="seccion-titulo"><span class="seccion-numero">&#9776;</span> Registros guardados</div>
                <div class="table-responsive">
                    <asp:GridView ID="gvRegistros" runat="server" CssClass="table table-sm table-hover tabla-registros mb-0"
                        AutoGenerateColumns="false" DataKeyNames="numero" SelectedRowStyle-CssClass="fila-seleccionada"
                        GridLines="None" OnSelectedIndexChanged="gvRegistros_SelectedIndexChanged" EmptyDataText="Todavía no hay registros.">
                        <Columns>
                            <asp:CommandField ShowSelectButton="true" SelectText="Seleccionar" />
                            <asp:BoundField DataField="numero" HeaderText="N°" />
                            <asp:BoundField DataField="cedula" HeaderText="Cédula" />
                            <asp:BoundField DataField="estudiante" HeaderText="Estudiante" />
                            <asp:BoundField DataField="genero" HeaderText="Género" />
                            <asp:BoundField DataField="fecha_nacimiento" HeaderText="Nacimiento" DataFormatString="{0:dd/MM/yyyy}" />
                            <asp:BoundField DataField="email" HeaderText="Correo" />
                            <asp:BoundField DataField="telefono" HeaderText="Teléfono" />
                            <asp:BoundField DataField="programa" HeaderText="Programa" />
                            <asp:BoundField DataField="semestre" HeaderText="Semestre" />
                            <asp:BoundField DataField="participacion" HeaderText="Participación" />
                            <asp:BoundField DataField="modalidad" HeaderText="Modalidad" />
                            <asp:BoundField DataField="tema" HeaderText="Tema" />
                            <asp:BoundField DataField="jornada" HeaderText="Jornada" />
                            <asp:BoundField DataField="fecha_inscripcion" HeaderText="Inscripción" DataFormatString="{0:dd/MM/yyyy}" />
                            <asp:BoundField DataField="comentarios" HeaderText="Comentarios" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </main>

    <script type="text/javascript">
        // Edad entre 15 y 80 años según la fecha de nacimiento (formato aaaa-mm-dd del campo fecha)
        function validateEdad(sender, args) {
            var partes = args.Value.split('-');
            if (partes.length !== 3) { args.IsValid = false; return; }
            var nacimiento = new Date(partes[0], partes[1] - 1, partes[2]);
            var hoy = new Date();
            var edad = hoy.getFullYear() - nacimiento.getFullYear();
            var m = hoy.getMonth() - nacimiento.getMonth();
            if (m < 0 || (m === 0 && hoy.getDate() < nacimiento.getDate())) { edad--; }
            args.IsValid = edad >= 15 && edad <= 80;
        }

        function validateAcepta(sender, args) {
            var cb = document.getElementById('<%= chkAcepta.ClientID %>');
            args.IsValid = cb && cb.checked;
        }
    </script>
</form>
</body>
</html>
