<%@ Page Title="Encuentro Académico" Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="EncuentroAcademico._Default" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Encuentro Académico</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,wght@0,500;0,600;1,600&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        :root {
            --tinta: #1b2559;
            --tinta-suave: #3b4683;
            --coral: #e8573f;
            --coral-oscuro: #c2412b;
            --papel: #f7f3ec;
            --blanco: #fffdf9;
            --linea: #e4dccd;
            --texto: #22252f;
            --gris: #6c6a73;
        }

        body { background: var(--papel); font-family: 'Inter', sans-serif; color: var(--texto); }
        h1, .titulo-serif { font-family: 'Fraunces', serif; }

        /* Diseño en dos columnas: panel lateral fijo + formulario */
        .pagina { padding: 32px 0 60px; }
        .lateral {
            background: var(--tinta); color: #fff; border-radius: 22px; padding: 32px 28px;
            position: relative; overflow: hidden; margin-bottom: 24px;
        }
        .lateral::after {
            content: ""; position: absolute; width: 220px; height: 220px; border-radius: 50%;
            border: 38px solid var(--coral); opacity: .9; right: -110px; bottom: -110px;
        }
        @media (min-width: 992px) { .lateral { position: sticky; top: 24px; min-height: calc(100vh - 48px); } }
        .lateral .etiqueta {
            display: inline-block; border: 1px solid rgba(255,255,255,.35); color: #fff;
            font-weight: 500; font-size: .72rem; letter-spacing: .14em; text-transform: uppercase;
            padding: 5px 12px; border-radius: 999px; margin-bottom: 22px;
        }
        .lateral h1 { font-weight: 600; font-size: 2.6rem; line-height: 1.05; margin: 0 0 14px; }
        .lateral h1 em { font-style: italic; color: var(--coral); }
        .lateral p { color: rgba(255,255,255,.75); margin: 0 0 28px; font-size: .95rem; }
        .pasos { list-style: none; padding: 0; margin: 0; position: relative; z-index: 1; }
        .pasos li { border-top: 1px solid rgba(255,255,255,.15); }
        .pasos a { display: flex; align-items: center; gap: 12px; padding: 12px 0; color: rgba(255,255,255,.85); text-decoration: none; font-size: .92rem; }
        .pasos a:hover { color: #fff; }
        .pasos span { font-family: 'Fraunces', serif; color: var(--coral); font-size: 1.1rem; width: 24px; }

        /* Tarjetas */
        .tarjeta { background: var(--blanco); border: 1px solid var(--linea); border-radius: 22px; }
        .seccion { padding: 28px 32px; border-bottom: 1px dashed var(--linea); scroll-margin-top: 16px; }
        .seccion:last-child { border-bottom: 0; }
        .seccion-titulo { display: flex; align-items: baseline; gap: 14px; margin-bottom: 20px; }
        .seccion-numero { font-family: 'Fraunces', serif; font-size: 2rem; line-height: 1; color: var(--coral); font-weight: 600; }
        .seccion-titulo .titulo-serif { font-size: 1.35rem; font-weight: 600; color: var(--tinta); }

        .campo-label { font-weight: 600; font-size: .78rem; letter-spacing: .06em; text-transform: uppercase; color: var(--tinta-suave); margin-bottom: 6px; display: block; }
        .form-control { height: 46px; border-radius: 12px; border: 1.5px solid var(--linea); background: #fff; color: var(--texto); }
        .form-control:focus { border-color: var(--tinta); box-shadow: 0 0 0 4px rgba(27, 37, 89, .1); }
        textarea.form-control { height: auto; }
        .error { color: var(--coral-oscuro); font-size: .8rem; font-weight: 500; display: block; margin-top: 4px; }

        /* Opciones (radio) como fichas */
        .opciones td { padding: 0 8px 8px 0; }
        .opciones input { position: absolute; opacity: 0; }
        .opciones label {
            display: inline-block; margin: 0; padding: 10px 20px; border: 1.5px solid var(--linea); border-radius: 12px;
            background: #fff; cursor: pointer; font-size: .9rem; font-weight: 500; transition: all .15s;
        }
        .opciones label:hover { border-color: var(--tinta); }
        .opciones input:checked + label { background: var(--tinta); border-color: var(--tinta); color: #fff; }
        .opciones input:focus + label { box-shadow: 0 0 0 4px rgba(27, 37, 89, .12); }

        /* Calendario */
        .calendario { width: 100%; border: 1.5px solid var(--linea) !important; border-radius: 14px; border-collapse: separate; overflow: hidden; background: #fff; font-size: .85rem; }
        .calendario td, .calendario th { padding: 7px 0; text-align: center; border: 0 !important; }
        .calendario > tbody > tr:first-child > td { background: var(--tinta) !important; padding: 0 !important; }
        .cal-titulo { background: var(--tinta) !important; color: #fff; font-family: 'Fraunces', serif; font-weight: 600; }
        .cal-titulo td { padding: 12px 0 !important; }
        .cal-titulo a, .cal-titulo td { color: #fff !important; }
        .cal-dias { color: var(--gris); font-weight: 600; font-size: .7rem; letter-spacing: .08em; text-transform: uppercase; }
        .cal-otro a { color: #c9c3b8 !important; }
        .cal-seleccion { background: var(--coral) !important; border-radius: 10px; font-weight: 700; }
        .cal-seleccion a { color: #fff !important; }
        .cal-hoy a { font-weight: 700; color: var(--coral); }
        .calendario a { color: inherit; text-decoration: none; display: block; }

        /* Casilla de aceptación */
        .acepta { background: var(--papel); border-radius: 12px; padding: 14px 16px; }
        .acepta input { width: 18px; height: 18px; accent-color: var(--tinta); vertical-align: middle; margin-right: 8px; }
        .acepta label { margin: 0; font-size: .9rem; vertical-align: middle; }

        /* Mensajes */
        .alert { border: 1px solid; border-radius: 14px; font-size: .92rem; padding: 14px 18px; }
        .alert-success { background: #eef6f0; border-color: #b9dcc3; color: #1e5631; }
        .alert-info { background: #eef0fa; border-color: #c9cfee; color: var(--tinta); }
        .alert-warning { background: #fdf3e3; border-color: #f0d6a8; color: #7a4a06; }
        .alert-danger { background: #fdeeea; border-color: #f4c3b8; color: #8a2a1a; }
        .alert-danger ul { margin: 6px 0 0; padding-left: 18px; }
        #pnlResult .card { border: 0; border-radius: 18px; background: var(--tinta); color: #fff; overflow: hidden; }
        #pnlResult .card-body { padding: 28px; }
        #pnlResult .text-success { color: var(--coral) !important; font-family: 'Fraunces', serif; font-weight: 600; letter-spacing: .02em; }
        #pnlResult .text-muted { color: rgba(255,255,255,.75) !important; }
        #pnlResult .alert-light { background: rgba(255,255,255,.08); border-color: rgba(255,255,255,.18); color: #fff; text-align: left; line-height: 1.8; }

        /* Botones */
        .barra-botones { background: var(--papel); padding: 22px 32px; border-top: 1px solid var(--linea); border-radius: 0 0 22px 22px; }
        .btn { border-radius: 999px; font-weight: 600; font-size: .82rem; letter-spacing: .1em; padding: 11px 22px; min-width: 140px; border: 1.5px solid; }
        .btn-crear { background: transparent; color: var(--tinta); border-color: var(--tinta); }
        .btn-crear:hover { background: var(--tinta); color: #fff; }
        .btn-registrar { background: var(--coral); color: #fff; border-color: var(--coral); box-shadow: 0 6px 16px rgba(232, 87, 63, .3); }
        .btn-registrar:hover { background: var(--coral-oscuro); border-color: var(--coral-oscuro); color: #fff; }
        .btn-actualizar { background: var(--tinta); color: #fff; border-color: var(--tinta); }
        .btn-actualizar:hover { background: var(--tinta-suave); color: #fff; }
        .btn-eliminar { background: transparent; color: var(--coral-oscuro); border-color: var(--coral-oscuro); }
        .btn-eliminar:hover { color: #fff; background: var(--coral-oscuro); }
        .btn:disabled { opacity: .35; box-shadow: none; }
        .ayuda { color: var(--gris); font-size: .82rem; }

        .aviso-edicion { background: var(--tinta); color: #fff; padding: 12px 16px; border-radius: 14px; display: block; margin-bottom: 0; font-size: .9rem; }
        .aviso-edicion strong { color: var(--coral); }

        /* Tabla de registros */
        .tabla-registros { border-collapse: separate; border-spacing: 0; }
        .tabla-registros th { background: transparent; color: var(--gris); font-weight: 600; font-size: .7rem; letter-spacing: .08em; text-transform: uppercase; white-space: nowrap; border-top: 0 !important; border-bottom: 2px solid var(--tinta) !important; }
        .tabla-registros td { font-size: .84rem; vertical-align: middle; border-top: 1px solid var(--linea); }
        .tabla-registros a { display: inline-block; color: var(--tinta); font-weight: 600; font-size: .78rem; border: 1.5px solid var(--tinta); border-radius: 999px; padding: 3px 12px; text-decoration: none; }
        .tabla-registros a:hover { background: var(--tinta); color: #fff; }
        .fila-seleccionada td { background: #fdeae5 !important; }

        @media (max-width: 575px) {
            .seccion, .barra-botones { padding-left: 18px; padding-right: 18px; }
            .lateral h1 { font-size: 2.1rem; }
            .btn { min-width: 0; width: 100%; margin-right: 0 !important; }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <div class="container-fluid pagina px-3 px-lg-4">
    <div class="row">
    <aside class="col-lg-4 col-xl-3">
        <header class="lateral">
            <span class="etiqueta">Inscripciones 2026</span>
            <h1>Encuentro <em>Académico</em></h1>
            <p>Registro de estudiantes — ASP.NET Web Forms, C# y SQL Server</p>
            <ul class="pasos">
                <li><a href="#datos"><span>1</span> Datos personales</a></li>
                <li><a href="#contacto"><span>2</span> Contacto</a></li>
                <li><a href="#academica"><span>3</span> Información académica</a></li>
                <li><a href="#participacion"><span>4</span> Participación en el encuentro</a></li>
                <li><a href="#registros"><span>&#9776;</span> Registros guardados</a></li>
            </ul>
        </header>
    </aside>

    <main class="col-lg-8 col-xl-9">
        <div class="tarjeta">
            <div class="seccion pb-0" style="border-bottom:0">
                <asp:Label ID="lblErrorConexion" runat="server" Visible="false" CssClass="alert alert-warning d-block" />
                <asp:ValidationSummary ID="vsSummary" runat="server" CssClass="alert alert-danger"
                    ValidationGroup="vg1" HeaderText="Revise los siguientes campos:" />
                <asp:Label ID="lblEditando" runat="server" Visible="false" CssClass="aviso-edicion" />
            </div>

            <!-- 1. Datos personales -->
            <section class="seccion" id="datos">
                <div class="seccion-titulo"><span class="seccion-numero">01</span><span class="titulo-serif">Datos personales</span></div>
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
            <section class="seccion" id="contacto">
                <div class="seccion-titulo"><span class="seccion-numero">02</span><span class="titulo-serif">Contacto</span></div>
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
            <section class="seccion" id="academica">
                <div class="seccion-titulo"><span class="seccion-numero">03</span><span class="titulo-serif">Información académica</span></div>
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
            <section class="seccion" id="participacion">
                <div class="seccion-titulo"><span class="seccion-numero">04</span><span class="titulo-serif">Participación en el encuentro</span></div>
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

                <div class="acepta mt-2">
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
                <div class="ayuda mt-1">
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
            <div class="seccion" id="registros">
                <div class="seccion-titulo"><span class="seccion-numero">&#9776;</span><span class="titulo-serif">Registros guardados</span></div>
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
    </div>
    </div>

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
