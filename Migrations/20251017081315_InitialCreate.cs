using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace IndigoAssistMVC.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AspNetRoles",
                columns: table => new
                {
                    Id = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: true),
                    NormalizedName = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: true),
                    ConcurrencyStamp = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetRoles", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "mComponentes",
                columns: table => new
                {
                    IdComponente = table.Column<byte>(type: "tinyint", nullable: false, comment: "Identificador único del componente")
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Componente = table.Column<string>(type: "nvarchar(80)", maxLength: 80, nullable: false, comment: "Nombre del componente"),
                    ValorBit = table.Column<int>(type: "int", nullable: true, comment: "Valor bit para codificación")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_mComponentes", x => x.IdComponente);
                });

            migrationBuilder.CreateTable(
                name: "mDepartamentos",
                columns: table => new
                {
                    IdDepto = table.Column<byte>(type: "tinyint", nullable: false, comment: "Identificador único del departamento")
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Departamento = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false, comment: "Nombre del departamento"),
                    Tickets = table.Column<bool>(type: "bit", nullable: false, defaultValue: false, comment: "Indica si el departamento acepta tickets")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_mDepartamentos", x => x.IdDepto);
                });

            migrationBuilder.CreateTable(
                name: "mPersonas",
                columns: table => new
                {
                    Persona = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Nombre = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Paterno = table.Column<string>(type: "nvarchar(25)", maxLength: 25, nullable: false),
                    Materno = table.Column<string>(type: "nvarchar(25)", maxLength: 25, nullable: false),
                    Descripcion = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    RFC = table.Column<string>(type: "nvarchar(13)", maxLength: 13, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    TipoPersona = table.Column<string>(type: "nvarchar(1)", maxLength: 1, nullable: false),
                    IdRegimenFiscal = table.Column<byte>(type: "tinyint", nullable: true),
                    IdUsoCFDI = table.Column<byte>(type: "tinyint", nullable: true),
                    IdReferencia = table.Column<int>(type: "int", nullable: true),
                    Usuario = table.Column<string>(type: "nvarchar(12)", maxLength: 12, nullable: false),
                    FeModifica = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_mPersonas", x => x.Persona);
                    table.ForeignKey(
                        name: "FK_mPersonas_mPersonas_IdReferencia",
                        column: x => x.IdReferencia,
                        principalTable: "mPersonas",
                        principalColumn: "Persona");
                });

            migrationBuilder.CreateTable(
                name: "mPrioridadTicket",
                columns: table => new
                {
                    IdPrioridad = table.Column<byte>(type: "tinyint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Prioridad = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_mPrioridadTicket", x => x.IdPrioridad);
                });

            migrationBuilder.CreateTable(
                name: "mProveedores",
                columns: table => new
                {
                    IdProveedor = table.Column<byte>(type: "tinyint", nullable: false, comment: "Identificador único del proveedor")
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Proveedor = table.Column<string>(type: "nvarchar(120)", maxLength: 120, nullable: false, comment: "Nombre del proveedor")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_mProveedores", x => x.IdProveedor);
                });

            migrationBuilder.CreateTable(
                name: "mSoftware",
                columns: table => new
                {
                    IdSoftware = table.Column<byte>(type: "tinyint", nullable: false, comment: "Identificador único del software")
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Nombre = table.Column<string>(type: "nvarchar(80)", maxLength: 80, nullable: false, comment: "Nombre del software")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_mSoftware", x => x.IdSoftware);
                });

            migrationBuilder.CreateTable(
                name: "mStatus",
                columns: table => new
                {
                    StatusId = table.Column<byte>(type: "tinyint", nullable: false, comment: "Identificador único del status")
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Status = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false, comment: "Nombre del status")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_mStatus", x => x.StatusId);
                });

            migrationBuilder.CreateTable(
                name: "mStatusTicket",
                columns: table => new
                {
                    Status = table.Column<byte>(type: "tinyint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    StatusDes = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_mStatusTicket", x => x.Status);
                });

            migrationBuilder.CreateTable(
                name: "mTiposActivo",
                columns: table => new
                {
                    IdTipoActivo = table.Column<byte>(type: "tinyint", nullable: false, comment: "Identificador único del tipo de activo")
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TipoActivo = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false, comment: "Nombre del tipo de activo")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_mTiposActivo", x => x.IdTipoActivo);
                });

            migrationBuilder.CreateTable(
                name: "mTipoTicket",
                columns: table => new
                {
                    IdTipoTicket = table.Column<byte>(type: "tinyint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    TipoTicket = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_mTipoTicket", x => x.IdTipoTicket);
                });

            migrationBuilder.CreateTable(
                name: "vTickets",
                columns: table => new
                {
                    IdTicket = table.Column<int>(type: "int", nullable: false),
                    IdSolicitante = table.Column<int>(type: "int", nullable: false),
                    Solicitante = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IdTecnico = table.Column<int>(type: "int", nullable: true),
                    Tecnico = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Titulo = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Descripcion = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Status = table.Column<byte>(type: "tinyint", nullable: false),
                    StatusDes = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IdTipoTicket = table.Column<byte>(type: "tinyint", nullable: true),
                    IdPrioridad = table.Column<byte>(type: "tinyint", nullable: true),
                    FeAlta = table.Column<DateTime>(type: "datetime2", nullable: false),
                    FeAsignacion = table.Column<DateTime>(type: "datetime2", nullable: true),
                    FeCompromiso = table.Column<DateTime>(type: "datetime2", nullable: true),
                    FeCierre = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IdSubCategoria = table.Column<byte>(type: "tinyint", nullable: false),
                    SubCategoria = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IdCategoria = table.Column<byte>(type: "tinyint", nullable: false),
                    Categoria = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    IdDepto = table.Column<byte>(type: "tinyint", nullable: false),
                    Departamento = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                });

            migrationBuilder.CreateTable(
                name: "AspNetRoleClaims",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RoleId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    ClaimType = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ClaimValue = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetRoleClaims", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetRoleClaims_AspNetRoles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "AspNetRoles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUsers",
                columns: table => new
                {
                    Id = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    NombreCompleto = table.Column<string>(type: "nvarchar(150)", maxLength: 150, nullable: false, comment: "Nombre completo del usuario"),
                    IdDepartamento = table.Column<byte>(type: "tinyint", nullable: true, comment: "ID del departamento"),
                    Activo = table.Column<bool>(type: "bit", nullable: false, defaultValue: true, comment: "Indica si el usuario está activo"),
                    FechaRegistro = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETDATE()", comment: "Fecha de registro del usuario"),
                    UltimoAcceso = table.Column<DateTime>(type: "datetime2", nullable: true, comment: "Último acceso del usuario"),
                    UserName = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: true),
                    NormalizedUserName = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: true),
                    Email = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: true),
                    NormalizedEmail = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: true),
                    EmailConfirmed = table.Column<bool>(type: "bit", nullable: false),
                    PasswordHash = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    SecurityStamp = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ConcurrencyStamp = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PhoneNumber = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PhoneNumberConfirmed = table.Column<bool>(type: "bit", nullable: false),
                    TwoFactorEnabled = table.Column<bool>(type: "bit", nullable: false),
                    LockoutEnd = table.Column<DateTimeOffset>(type: "datetimeoffset", nullable: true),
                    LockoutEnabled = table.Column<bool>(type: "bit", nullable: false),
                    AccessFailedCount = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUsers", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetUsers_mDepartamentos_IdDepartamento",
                        column: x => x.IdDepartamento,
                        principalTable: "mDepartamentos",
                        principalColumn: "IdDepto",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "mCategoriasTicket",
                columns: table => new
                {
                    IdCategoria = table.Column<byte>(type: "tinyint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Categoria = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: false),
                    IdDepto = table.Column<byte>(type: "tinyint", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_mCategoriasTicket", x => x.IdCategoria);
                    table.ForeignKey(
                        name: "FK_mCategoriasTicket_mDepartamentos_IdDepto",
                        column: x => x.IdDepto,
                        principalTable: "mDepartamentos",
                        principalColumn: "IdDepto",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "mPuestos",
                columns: table => new
                {
                    IdPuesto = table.Column<byte>(type: "tinyint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Puesto = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    IdDepto = table.Column<byte>(type: "tinyint", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_mPuestos", x => x.IdPuesto);
                    table.ForeignKey(
                        name: "FK_mPuestos_mDepartamentos_IdDepto",
                        column: x => x.IdDepto,
                        principalTable: "mDepartamentos",
                        principalColumn: "IdDepto",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "mEmpresas",
                columns: table => new
                {
                    IdEmpresa = table.Column<byte>(type: "tinyint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Persona = table.Column<int>(type: "int", nullable: false),
                    Logo = table.Column<byte[]>(type: "varbinary(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_mEmpresas", x => x.IdEmpresa);
                    table.ForeignKey(
                        name: "FK_mEmpresas_mPersonas_Persona",
                        column: x => x.Persona,
                        principalTable: "mPersonas",
                        principalColumn: "Persona");
                });

            migrationBuilder.CreateTable(
                name: "mActivos",
                columns: table => new
                {
                    IdActivo = table.Column<int>(type: "int", nullable: false, comment: "Identificador único del activo")
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Codigo = table.Column<string>(type: "nvarchar(40)", maxLength: 40, nullable: false, comment: "Código único del activo"),
                    Marca = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true, comment: "Marca del activo"),
                    Modelo = table.Column<string>(type: "nvarchar(80)", maxLength: 80, nullable: true, comment: "Modelo del activo"),
                    Serie = table.Column<string>(type: "nvarchar(80)", maxLength: 80, nullable: true, comment: "Número de serie del activo"),
                    Nombre = table.Column<string>(type: "nvarchar(120)", maxLength: 120, nullable: false, comment: "Nombre descriptivo del activo"),
                    PersonaAsign = table.Column<string>(type: "nvarchar(120)", maxLength: 120, nullable: true, comment: "Persona asignada al activo"),
                    Ubicacion = table.Column<string>(type: "nvarchar(120)", maxLength: 120, nullable: true, comment: "Ubicación física del activo"),
                    FeAlta = table.Column<DateTime>(type: "date", nullable: false, comment: "Fecha de alta del activo"),
                    FeCompra = table.Column<DateTime>(type: "date", nullable: true, comment: "Fecha de compra del activo"),
                    FeBaja = table.Column<DateTime>(type: "date", nullable: true, comment: "Fecha de baja del activo"),
                    CostoCompra = table.Column<decimal>(type: "decimal(12,2)", nullable: true, comment: "Costo de compra del activo"),
                    Notas = table.Column<string>(type: "nvarchar(400)", maxLength: 400, nullable: true, comment: "Notas adicionales sobre el activo"),
                    CodificacionComponentes = table.Column<int>(type: "int", nullable: false, comment: "Codificación de componentes"),
                    TieneSoftwareOP = table.Column<bool>(type: "bit", nullable: false, comment: "Indica si tiene software OP"),
                    IdTipoActivo = table.Column<byte>(type: "tinyint", nullable: false, comment: "Tipo de activo"),
                    IdDepartamento = table.Column<byte>(type: "tinyint", nullable: false, comment: "Departamento"),
                    IdStatus = table.Column<byte>(type: "tinyint", nullable: false, comment: "Status del activo"),
                    IdProveedor = table.Column<byte>(type: "tinyint", nullable: false, comment: "Proveedor")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_mActivos", x => x.IdActivo);
                    table.ForeignKey(
                        name: "FK_mActivos_mDepartamentos_IdDepartamento",
                        column: x => x.IdDepartamento,
                        principalTable: "mDepartamentos",
                        principalColumn: "IdDepto",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_mActivos_mProveedores_IdProveedor",
                        column: x => x.IdProveedor,
                        principalTable: "mProveedores",
                        principalColumn: "IdProveedor",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_mActivos_mStatus_IdStatus",
                        column: x => x.IdStatus,
                        principalTable: "mStatus",
                        principalColumn: "StatusId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_mActivos_mTiposActivo_IdTipoActivo",
                        column: x => x.IdTipoActivo,
                        principalTable: "mTiposActivo",
                        principalColumn: "IdTipoActivo",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserClaims",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    ClaimType = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ClaimValue = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserClaims", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetUserClaims_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserLogins",
                columns: table => new
                {
                    LoginProvider = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    ProviderKey = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    ProviderDisplayName = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserLogins", x => new { x.LoginProvider, x.ProviderKey });
                    table.ForeignKey(
                        name: "FK_AspNetUserLogins_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserRoles",
                columns: table => new
                {
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    RoleId = table.Column<string>(type: "nvarchar(450)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserRoles", x => new { x.UserId, x.RoleId });
                    table.ForeignKey(
                        name: "FK_AspNetUserRoles_AspNetRoles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "AspNetRoles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AspNetUserRoles_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserTokens",
                columns: table => new
                {
                    UserId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    LoginProvider = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    Value = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserTokens", x => new { x.UserId, x.LoginProvider, x.Name });
                    table.ForeignKey(
                        name: "FK_AspNetUserTokens_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "mSubCategoriasTicket",
                columns: table => new
                {
                    IdSubCategoria = table.Column<byte>(type: "tinyint", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    SubCategoria = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: false),
                    IdCategoria = table.Column<byte>(type: "tinyint", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_mSubCategoriasTicket", x => x.IdSubCategoria);
                    table.ForeignKey(
                        name: "FK_mSubCategoriasTicket_mCategoriasTicket_IdCategoria",
                        column: x => x.IdCategoria,
                        principalTable: "mCategoriasTicket",
                        principalColumn: "IdCategoria",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "mPerEmp",
                columns: table => new
                {
                    IdPersona = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    IdEmpresa = table.Column<byte>(type: "tinyint", nullable: false),
                    Persona = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_mPerEmp", x => x.IdPersona);
                    table.ForeignKey(
                        name: "FK_mPerEmp_mEmpresas_IdEmpresa",
                        column: x => x.IdEmpresa,
                        principalTable: "mEmpresas",
                        principalColumn: "IdEmpresa");
                    table.ForeignKey(
                        name: "FK_mPerEmp_mPersonas_Persona",
                        column: x => x.Persona,
                        principalTable: "mPersonas",
                        principalColumn: "Persona");
                });

            migrationBuilder.CreateTable(
                name: "mEmpleados",
                columns: table => new
                {
                    IdPersona = table.Column<int>(type: "int", nullable: false),
                    Login = table.Column<string>(type: "nvarchar(12)", maxLength: 12, nullable: true),
                    Activo = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_mEmpleados", x => x.IdPersona);
                    table.ForeignKey(
                        name: "FK_mEmpleados_mPerEmp_IdPersona",
                        column: x => x.IdPersona,
                        principalTable: "mPerEmp",
                        principalColumn: "IdPersona");
                });

            migrationBuilder.CreateTable(
                name: "mTickets",
                columns: table => new
                {
                    IdTicket = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Usuario = table.Column<int>(type: "int", nullable: false),
                    IdSubCategoria = table.Column<byte>(type: "tinyint", nullable: false),
                    Titulo = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Descripcion = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Status = table.Column<byte>(type: "tinyint", nullable: false),
                    IdTipoTicket = table.Column<byte>(type: "tinyint", nullable: true),
                    Prioridad = table.Column<byte>(type: "tinyint", nullable: true),
                    FeAlta = table.Column<DateTime>(type: "datetime2", nullable: false),
                    FeAsignacion = table.Column<DateTime>(type: "datetime2", nullable: true),
                    FeCompromiso = table.Column<DateTime>(type: "datetime2", nullable: true),
                    FeCierre = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_mTickets", x => x.IdTicket);
                    table.ForeignKey(
                        name: "FK_mTickets_mPerEmp_Usuario",
                        column: x => x.Usuario,
                        principalTable: "mPerEmp",
                        principalColumn: "IdPersona",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_mTickets_mPrioridadTicket_Prioridad",
                        column: x => x.Prioridad,
                        principalTable: "mPrioridadTicket",
                        principalColumn: "IdPrioridad");
                    table.ForeignKey(
                        name: "FK_mTickets_mStatusTicket_Status",
                        column: x => x.Status,
                        principalTable: "mStatusTicket",
                        principalColumn: "Status",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_mTickets_mSubCategoriasTicket_IdSubCategoria",
                        column: x => x.IdSubCategoria,
                        principalTable: "mSubCategoriasTicket",
                        principalColumn: "IdSubCategoria",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_mTickets_mTipoTicket_IdTipoTicket",
                        column: x => x.IdTipoTicket,
                        principalTable: "mTipoTicket",
                        principalColumn: "IdTipoTicket");
                });

            migrationBuilder.CreateTable(
                name: "dEmpleados",
                columns: table => new
                {
                    IdPersona = table.Column<int>(type: "int", nullable: false),
                    IdPuesto = table.Column<byte>(type: "tinyint", nullable: false),
                    Principal = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_dEmpleados", x => new { x.IdPersona, x.IdPuesto });
                    table.ForeignKey(
                        name: "FK_dEmpleados_mEmpleados_IdPersona",
                        column: x => x.IdPersona,
                        principalTable: "mEmpleados",
                        principalColumn: "IdPersona");
                    table.ForeignKey(
                        name: "FK_dEmpleados_mPersonas_IdPersona",
                        column: x => x.IdPersona,
                        principalTable: "mPersonas",
                        principalColumn: "Persona",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_dEmpleados_mPuestos_IdPuesto",
                        column: x => x.IdPuesto,
                        principalTable: "mPuestos",
                        principalColumn: "IdPuesto");
                });

            migrationBuilder.CreateTable(
                name: "dTicketsTecnicos",
                columns: table => new
                {
                    IdTicket = table.Column<int>(type: "int", nullable: false),
                    IdPersona = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_dTicketsTecnicos", x => new { x.IdTicket, x.IdPersona });
                    table.ForeignKey(
                        name: "FK_dTicketsTecnicos_mEmpleados_IdPersona",
                        column: x => x.IdPersona,
                        principalTable: "mEmpleados",
                        principalColumn: "IdPersona",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_dTicketsTecnicos_mTickets_IdTicket",
                        column: x => x.IdTicket,
                        principalTable: "mTickets",
                        principalColumn: "IdTicket",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_AspNetRoleClaims_RoleId",
                table: "AspNetRoleClaims",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "RoleNameIndex",
                table: "AspNetRoles",
                column: "NormalizedName",
                unique: true,
                filter: "[NormalizedName] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserClaims_UserId",
                table: "AspNetUserClaims",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserLogins_UserId",
                table: "AspNetUserLogins",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserRoles_RoleId",
                table: "AspNetUserRoles",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "EmailIndex",
                table: "AspNetUsers",
                column: "NormalizedEmail");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUsers_IdDepartamento",
                table: "AspNetUsers",
                column: "IdDepartamento");

            migrationBuilder.CreateIndex(
                name: "UserNameIndex",
                table: "AspNetUsers",
                column: "NormalizedUserName",
                unique: true,
                filter: "[NormalizedUserName] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "IX_dEmpleados_IdPuesto",
                table: "dEmpleados",
                column: "IdPuesto");

            migrationBuilder.CreateIndex(
                name: "IX_dTicketsTecnicos_IdPersona",
                table: "dTicketsTecnicos",
                column: "IdPersona");

            migrationBuilder.CreateIndex(
                name: "IX_mActivos_IdDepartamento",
                table: "mActivos",
                column: "IdDepartamento");

            migrationBuilder.CreateIndex(
                name: "IX_mActivos_IdProveedor",
                table: "mActivos",
                column: "IdProveedor");

            migrationBuilder.CreateIndex(
                name: "IX_mActivos_IdStatus",
                table: "mActivos",
                column: "IdStatus");

            migrationBuilder.CreateIndex(
                name: "IX_mActivos_IdTipoActivo",
                table: "mActivos",
                column: "IdTipoActivo");

            migrationBuilder.CreateIndex(
                name: "IX_mCategoriasTicket_IdDepto",
                table: "mCategoriasTicket",
                column: "IdDepto");

            migrationBuilder.CreateIndex(
                name: "IX_mEmpresas_Persona",
                table: "mEmpresas",
                column: "Persona");

            migrationBuilder.CreateIndex(
                name: "IX_mPerEmp_IdEmpresa",
                table: "mPerEmp",
                column: "IdEmpresa");

            migrationBuilder.CreateIndex(
                name: "IX_mPerEmp_Persona",
                table: "mPerEmp",
                column: "Persona");

            migrationBuilder.CreateIndex(
                name: "IX_mPersonas_IdReferencia",
                table: "mPersonas",
                column: "IdReferencia");

            migrationBuilder.CreateIndex(
                name: "IX_mPuestos_IdDepto",
                table: "mPuestos",
                column: "IdDepto");

            migrationBuilder.CreateIndex(
                name: "IX_mSubCategoriasTicket_IdCategoria",
                table: "mSubCategoriasTicket",
                column: "IdCategoria");

            migrationBuilder.CreateIndex(
                name: "IX_mTickets_IdSubCategoria",
                table: "mTickets",
                column: "IdSubCategoria");

            migrationBuilder.CreateIndex(
                name: "IX_mTickets_IdTipoTicket",
                table: "mTickets",
                column: "IdTipoTicket");

            migrationBuilder.CreateIndex(
                name: "IX_mTickets_Prioridad",
                table: "mTickets",
                column: "Prioridad");

            migrationBuilder.CreateIndex(
                name: "IX_mTickets_Status",
                table: "mTickets",
                column: "Status");

            migrationBuilder.CreateIndex(
                name: "IX_mTickets_Usuario",
                table: "mTickets",
                column: "Usuario");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AspNetRoleClaims");

            migrationBuilder.DropTable(
                name: "AspNetUserClaims");

            migrationBuilder.DropTable(
                name: "AspNetUserLogins");

            migrationBuilder.DropTable(
                name: "AspNetUserRoles");

            migrationBuilder.DropTable(
                name: "AspNetUserTokens");

            migrationBuilder.DropTable(
                name: "dEmpleados");

            migrationBuilder.DropTable(
                name: "dTicketsTecnicos");

            migrationBuilder.DropTable(
                name: "mActivos");

            migrationBuilder.DropTable(
                name: "mComponentes");

            migrationBuilder.DropTable(
                name: "mSoftware");

            migrationBuilder.DropTable(
                name: "vTickets");

            migrationBuilder.DropTable(
                name: "AspNetRoles");

            migrationBuilder.DropTable(
                name: "AspNetUsers");

            migrationBuilder.DropTable(
                name: "mPuestos");

            migrationBuilder.DropTable(
                name: "mEmpleados");

            migrationBuilder.DropTable(
                name: "mTickets");

            migrationBuilder.DropTable(
                name: "mProveedores");

            migrationBuilder.DropTable(
                name: "mStatus");

            migrationBuilder.DropTable(
                name: "mTiposActivo");

            migrationBuilder.DropTable(
                name: "mPerEmp");

            migrationBuilder.DropTable(
                name: "mPrioridadTicket");

            migrationBuilder.DropTable(
                name: "mStatusTicket");

            migrationBuilder.DropTable(
                name: "mSubCategoriasTicket");

            migrationBuilder.DropTable(
                name: "mTipoTicket");

            migrationBuilder.DropTable(
                name: "mEmpresas");

            migrationBuilder.DropTable(
                name: "mCategoriasTicket");

            migrationBuilder.DropTable(
                name: "mPersonas");

            migrationBuilder.DropTable(
                name: "mDepartamentos");
        }
    }
}
