# Encuentro Académico — avance de arquitectura en tres capas + MVP

Este proyecto parte de la solución Web Forms que ya tenía el equipo. El dominio actual es el **registro de estudiantes a un encuentro académico** (estudiante, programa, semestre, tema, jornada y tipo de participación). El portal `Portal.aspx` amplía el proyecto con inicio de sesión y administración de actividades académicas e inscripciones en una tabla relacionada con estudiantes.

## Estructura

```text
EncuentroAcademico.sln
├── EncuentroAcademico                 Presentación: Web Forms, contrato de vista y Presenter
├── EncuentroAcademico.BLL             Negocio: validaciones y reglas
├── EncuentroAcademico.DAL             Datos: repositorio ADO.NET y SQL parametrizado
└── EncuentroAcademico.Entities        DTO compartidos
```

Flujo: `Default.aspx → RegistroPresenter → RegistroService → RegistroRepository → SQL Server`.
El Presenter implementa la coordinación de MVP dentro de la capa de presentación. DAL no referencia Web.

## Funcionalidad incluida

- Crear, consultar, seleccionar, actualizar y eliminar registros.
- Listar y cargar catálogos de programas, semestres, participación, temas y jornadas.
- Validaciones de servidor en Web Forms y BLL: campos obligatorios, formato de cédula/correo/teléfono, edad entre 15 y 80, catálogos válidos, modalidad y longitud de comentarios.
- Consultas con `SqlParameter`; las operaciones de escritura se agrupan en transacciones.
- Mensajes de resultado sin exponer errores SQL al usuario. El detalle técnico se envía a `Trace`.

## Requisitos locales

- Visual Studio con carga de trabajo ASP.NET y soporte para proyectos Web Forms.
- .NET Framework 4.8.1 (se alineó la solución con la guía del proyecto).
- SQL Server y SQL Server Management Studio (SSMS).
- La conexión de esta copia está configurada en `EncuentroAcademico/Web.config` como `Data Source=.\SQLEXPRESS`. Cambia ese valor por el nombre de instancia que uses en SSMS si es distinto. No pongas contraseñas reales en GitHub. La conexión no se pudo probar aquí.

## Ejecutar

1. Abre `EncuentroAcademico.sln` en Visual Studio.
2. Conéctate a tu instancia de SQL Server en SSMS y ejecuta `01_BaseDeDatos.sql`. El script conserva datos, crea las tablas que falten y agrega catálogos sin duplicarlos. Para bases muy antiguas revisa antes el respaldo y compara el esquema.
3. Ajusta `Data Source` en `EncuentroAcademico/Web.config` para que coincida con SSMS.
4. Compila la solución y pulsa F5 con `EncuentroAcademico` como proyecto de inicio.
5. Prueba el formulario usando datos ficticios. `02_VerRegistros.sql` consulta las filas persistidas.

## Pruebas funcionales para completar en el PC del equipo

| Caso | Acción | Resultado esperado | Estado |
|---|---|---|---|
| Registro correcto | Completar todos los campos y guardar | Registro aparece en el listado y en SQL Server | Pendiente en SQL Server del equipo |
| Cédula inválida | Usar menos de 5 dígitos o letras | Validación visible y no inserta | Pendiente en navegador |
| Campo obligatorio | Omitir título/cédula u otro dato requerido | Validación visible y no inserta | Pendiente en navegador |
| Edad fuera del rango | Fecha que dé menos de 15 o más de 80 años | Rechazo del servidor | Pendiente en navegador |
| Actualizar | Seleccionar una fila, editar y guardar | Cambios persisten | Pendiente en SQL Server del equipo |
| Eliminar | Seleccionar fila y confirmar | Fila eliminada y listado actualizado | Pendiente en SQL Server del equipo |
| Sin conexión | Apagar instancia o cambiar temporalmente Data Source | Mensaje controlado sin datos internos | Pendiente en navegador |

Las librerías Entities, DAL, BLL y el code-behind/Presenter se compilaron con el compilador C# disponible. Una comprobación aislada de las reglas de negocio pasó 9 de 9 casos con datos ficticios; solo valida la BLL y no comprueba persistencia. No se pudo compilar la aplicación Web Forms ni ejecutar operaciones contra SQL porque faltan el targeting pack/componente Web Forms y ninguna instancia SQL Server local respondió. Las pruebas de integración siguen pendientes. Consulta `Resultados_Pruebas_Estaticas.txt` para el detalle. La imagen `Vista_Previa_Estatica.png` es solo una muestra visual con datos ficticios; no ejecuta la aplicación.

## Entrega y pendientes

- Informe técnico: `01_Informe_Tecnico.pdf`.
- Script de base de datos: `03_BaseDatos.sql` (copia de `01_BaseDeDatos.sql` al preparar el paquete).
- Solución fuente: `02_Solucion_VisualStudio.zip` (se excluyen `bin`, `obj`, `.vs` y archivos de usuario).
- Añadir integrantes, revisar alcance con la docente, abrir y compilar la solución en Visual Studio, ejecutar el flujo en SQL Server y guardar capturas reales de evidencia.
- Publicar en GitHub desde la cuenta del equipo e invitar a la docente. No subir cadenas con credenciales. No se ha creado ni publicado un repositorio desde esta copia.

## Integrantes

- Integrante 1: completar nombre y aporte.
- Integrante 2: completar nombre y aporte.
- Integrante 3: completar nombre y aporte.

## Lista para la entrega final

La entrega final puede incluir gestión de actividades UniCampus, filtros, detalles, inscripciones con control de cupos y reseñas, solo después de definir el modelo correspondiente. Esas funcionalidades no se presentan como implementadas en esta solución.




## Portal de actividades académicas
Abre la solución en Visual Studio 2022 con .NET Framework 4.8.1. Ejecuta primero `01_BaseDeDatos.sql` en SQL Server Management Studio y revisa `Web.config` para indicar tu servidor SQL. La página inicial es `Portal.aspx`.

Incluye inicio de sesión con contraseña derivada PBKDF2, resumen (actividades, inscritos, próximas y finalizadas), alta y búsqueda de actividades, cancelación lógica, y administración de inscripciones relacionadas con `Estudiantes`. El menú desplegable permite entrar al resumen, actividades, estudiantes inscritos y registro previo.

**Cuenta de demostración:** `admin@unicampus.edu` / `Demo2026!` (solo para la base local de clase; cambia la contraseña antes de cualquier despliegue real).

**Alcance de verificación:** se compiló de forma aislada el código C# de Portal.aspx y se revisaron la estructura de configuración y el esquema SQL. No se pudo hacer prueba integrada de inicio de sesión/CRUD porque no hay instancia SQL Server disponible en este equipo. Al ejecutar el script, las cuentas de demostración se crean junto con el esquema.


Flujo del portal: Portal.aspx → AcademicoService (BLL) → AcademicoRepository (DAL) → SQL Server. Las escrituras usan parámetros SQL y la inscripción verifica estado, fecha, duplicado y cupos dentro de una transacción serializable.

