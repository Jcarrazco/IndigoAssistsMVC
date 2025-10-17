USE [IndigoBasic]
GO
/****** Object:  UserDefinedFunction [dbo].[GetAnotacionesTecnicosTicket]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Carlos Rivera
-- Create date: 09-nov-2023
-- Description:	Regresa las anotaciones de los tecnicos que atendieron el ticket
-- =============================================

CREATE FUNCTION [dbo].[GetAnotacionesTecnicosTicket](@Historico BIT,
													 @IdTicket INT)
RETURNS
	@Result TABLE(IdDTicket INT, 
				  Evento NVARCHAR(MAX),
				  Tiempo NVARCHAR(6),
				  Fecha DATETIME,
				  Usuario NVARCHAR(12))
AS
BEGIN
	IF(@Historico = 0)
	BEGIN
		INSERT INTO @Result (IdDTicket, Evento, Tiempo, Fecha, Usuario)
		SELECT dTickets.IdDTicket, dTickets.Evento, dTickets.Tiempo, dTickets.Fecha, LOWER(dTickets.Usuario)
		FROM dTickets
		WHERE dTickets.IdTicket = @IdTicket
		AND dTickets.Evento <> ''
		ORDER BY dTickets.Fecha ASC
	END
	ELSE
	BEGIN
		INSERT INTO @Result (IdDTicket, Evento, Tiempo, Fecha, Usuario)
		SELECT hdTickets.IdDTicket, hdTickets.Evento, hdTickets.Tiempo, hdTickets.Fecha, LOWER(hdTickets.Usuario)
		FROM hdTickets
		WHERE hdTickets.IdTicket = @IdTicket
		AND hdTickets.Evento <> ''
		ORDER BY hdTickets.Fecha ASC
	END

	RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetSysVar]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Sistema
-- Create date: 
-- Description:	Obtiene el valor de una variable del sistema desde mSysVar
-- =============================================
CREATE FUNCTION [dbo].[GetSysVar] 
(
	-- Add the parameters for the function here
	@variable nvarchar(20)
)
RETURNS nvarchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result nvarchar(50)
	
	-- Add the T-SQL statements to compute the return value here
	Select @Result = mSysVar.Valor   
	From mSysVar 
	Where mSysVar.Variable = @variable   

	-- Return the result of the function
	RETURN @Result

END
GO
/****** Object:  Table [dbo].[mEmpleados]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mEmpleados](
	[IdPersona] [int] NOT NULL,
	[Login] [nvarchar](12) NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_mEmpleados] PRIMARY KEY CLUSTERED 
(
	[IdPersona] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mDepartamentos]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mDepartamentos](
	[IdDepto] [tinyint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Departamento] [nvarchar](50) NOT NULL,
	[Tickets] [bit] NOT NULL,
 CONSTRAINT [PK_mDepartamentos] PRIMARY KEY CLUSTERED 
(
	[IdDepto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mPuestos]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mPuestos](
	[IdPuesto] [tinyint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Puesto] [nvarchar](50) NOT NULL,
	[IdDepto] [tinyint] NOT NULL,
 CONSTRAINT [PK_mPuestos] PRIMARY KEY CLUSTERED 
(
	[IdPuesto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dEmpleados]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dEmpleados](
	[IdPersona] [int] NOT NULL,
	[IdPuesto] [tinyint] NOT NULL,
	[Principal] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vEmpleados]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vEmpleados] AS 
	SELECT mEmpleados.IdPersona, mEmpleados.Login, mEmpleados.Activo, dEmpleados.IdPuesto, mPuestos.Puesto, dEmpleados.Principal, mPuestos.IdDepto, 
	mDepartamentos.Departamento, mDepartamentos.Tickets
	FROM mEmpleados INNER JOIN 
	dEmpleados ON mEmpleados.IdPersona = dEmpleados.IdPersona INNER JOIN
	mPuestos ON dEmpleados.IdPuesto = mPuestos.IdPuesto INNER JOIN 
	mDepartamentos ON mPuestos.IdDepto = mDepartamentos.IdDepto
GO
/****** Object:  Table [dbo].[mStatusTicket]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mStatusTicket](
	[Status] [tinyint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[StatusDes] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_mStatusTicket] PRIMARY KEY CLUSTERED 
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mCategoriasTicket]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mCategoriasTicket](
	[IdCategoria] [tinyint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Categoria] [nvarchar](30) NOT NULL,
	[IdDepto] [tinyint] NOT NULL,
 CONSTRAINT [PK_mCategoriasTicket] PRIMARY KEY CLUSTERED 
(
	[IdCategoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mSubCategoriasTicket]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mSubCategoriasTicket](
	[IdSubCategoria] [tinyint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SubCategoria] [nvarchar](30) NOT NULL,
	[IdCategoria] [tinyint] NOT NULL,
 CONSTRAINT [PK_mSubCategoriasTicket] PRIMARY KEY CLUSTERED 
(
	[IdSubCategoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mTickets]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mTickets](
	[IdTicket] [int] IDENTITY(1,1) NOT NULL,
	[Usuario] [int] NOT NULL,
	[IdSubCategoria] [tinyint] NOT NULL,
	[Titulo] [nvarchar](50) NOT NULL,
	[Descripcion] [nvarchar](max) NOT NULL,
	[Status] [tinyint] NOT NULL,
	[IdTipoTicket] [tinyint] NULL,
	[Prioridad] [tinyint] NULL,
	[FeAlta] [smalldatetime] NOT NULL,
	[FeAsignacion] [smalldatetime] NULL,
	[FeCompromiso] [smalldatetime] NULL,
	[FeCierre] [smalldatetime] NULL,
 CONSTRAINT [PK_mTickets] PRIMARY KEY CLUSTERED 
(
	[IdTicket] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dTicketsTecnicos]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dTicketsTecnicos](
	[IdTicket] [int] NOT NULL,
	[IdPersona] [int] NOT NULL,
 CONSTRAINT [PK_dTicketsTecnicos] PRIMARY KEY CLUSTERED 
(
	[IdTicket] ASC,
	[IdPersona] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vTickets]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vTickets] AS

	SELECT mTickets.IdTicket, mTickets.Usuario AS IdSolicitante, mEmpleados.Login AS Solicitante, dTicketsTecnicos.IdPersona AS IdTecnico,
	CASE WHEN dTicketsTecnicos.IdPersona IS NULL THEN '' 
		 ELSE (SELECT TOP 1 Login
			   FROM mEmpleados
			   WHERE mEmpleados.IdPersona = dTicketsTecnicos.IdPersona
			   ORDER BY mEmpleados.Login)
	END AS Tecnico,	
	mTickets.Titulo, mTickets.Descripcion, mStatusTicket.Status, mStatusTicket.StatusDes, mTickets.IdTipoTicket, mTickets.Prioridad AS IdPrioridad,
	mTickets.FeAlta, mTickets.FeAsignacion, mTickets.FeCompromiso, mTickets.FeCierre,
	mSubCategoriasTicket.IdSubCategoria, mSubCategoriasTicket.SubCategoria,	mCategoriasTicket.IdCategoria, mCategoriasTicket.Categoria,
	mDepartamentos.IdDepto, mDepartamentos.Departamento
	FROM mTickets INNER JOIN
	mEmpleados ON mTickets.Usuario = mEmpleados.IdPersona INNER JOIN
	mSubCategoriasTicket ON mTickets.IdSubCategoria = mSubCategoriasTicket.IdSubCategoria INNER JOIN
	mCategoriasTicket ON mSubCategoriasTicket.IdCategoria = mCategoriasTicket.IdCategoria INNER JOIN
	mDepartamentos ON mCategoriasTicket.IdDepto = mDepartamentos.IdDepto INNER JOIN
	mStatusTicket ON mTickets.Status = mStatusTicket.Status LEFT OUTER JOIN
	dTicketsTecnicos ON mTickets.IdTicket = dTicketsTecnicos.IdTicket
GO
/****** Object:  Table [dbo].[hTickets]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hTickets](
	[IdTicket] [int] NOT NULL,
	[Usuario] [int] NOT NULL,
	[IdSubCategoria] [tinyint] NOT NULL,
	[Titulo] [nvarchar](50) NOT NULL,
	[Descripcion] [nvarchar](max) NOT NULL,
	[IdTipoTicket] [tinyint] NULL,
	[Prioridad] [tinyint] NULL,
	[FeAlta] [smalldatetime] NOT NULL,
	[FeAsignacion] [smalldatetime] NULL,
	[FeCompromiso] [smalldatetime] NULL,
	[FeCierre] [smalldatetime] NULL,
 CONSTRAINT [PK_hTickets] PRIMARY KEY CLUSTERED 
(
	[IdTicket] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[hdTicketsTecnicos]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hdTicketsTecnicos](
	[IdTicket] [int] NOT NULL,
	[IdPersona] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vhTickets]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vhTickets] AS 

	SELECT hTickets.IdTicket, hTickets.Usuario AS IdSolicitante, mEmpleados.Login AS Solicitante, hdTicketsTecnicos.IdPersona AS IdTecnico,
	CASE WHEN hdTicketsTecnicos.IdPersona IS NULL THEN '' 
		 ELSE (SELECT TOP 1 Login
			   FROM mEmpleados
			   WHERE mEmpleados.IdPersona = hdTicketsTecnicos.IdPersona
			   ORDER BY mEmpleados.Login)
	END AS Tecnico,	
	hTickets.Titulo, hTickets.Descripcion, 3 AS Status, 'Cerrado' AS StatusDes,  hTickets.IdTipoTicket, hTickets.Prioridad AS IdPrioridad,
	hTickets.FeAlta, hTickets.FeAsignacion, hTickets.FeCompromiso, hTickets.FeCierre,
	mSubCategoriasTicket.IdSubCategoria, mSubCategoriasTicket.SubCategoria,	mCategoriasTicket.IdCategoria, mCategoriasTicket.Categoria,
	mDepartamentos.IdDepto, mDepartamentos.Departamento
	FROM hTickets INNER JOIN
	mEmpleados ON hTickets.Usuario = mEmpleados.IdPersona INNER JOIN
	mSubCategoriasTicket ON hTickets.IdSubCategoria = mSubCategoriasTicket.IdSubCategoria INNER JOIN
	mCategoriasTicket ON mSubCategoriasTicket.IdCategoria = mCategoriasTicket.IdCategoria INNER JOIN
	mDepartamentos ON mCategoriasTicket.IdDepto = mDepartamentos.IdDepto LEFT OUTER JOIN
	hdTicketsTecnicos ON hTickets.IdTicket = hdTicketsTecnicos.IdTicket
GO
/****** Object:  Table [dbo].[mPersonas]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mPersonas](
	[Persona] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[Paterno] [nvarchar](25) NOT NULL,
	[Materno] [nvarchar](25) NOT NULL,
	[Descripcion] [nvarchar](50) NULL,
	[RFC] [nvarchar](13) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[TipoPersona] [nvarchar](1) NOT NULL,
	[IdRegimenFiscal] [tinyint] NULL,
	[IdUsoCFDI] [tinyint] NULL,
	[IdReferencia] [int] NULL,
	[Usuario] [nvarchar](12) NOT NULL,
	[FeModifica] [smalldatetime] NULL,
 CONSTRAINT [PK_mPersonas] PRIMARY KEY CLUSTERED 
(
	[Persona] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mEmpresas]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mEmpresas](
	[IdEmpresa] [tinyint] IDENTITY(1,1) NOT NULL,
	[Persona] [int] NOT NULL,
	[Logo] [image] NULL,
 CONSTRAINT [PK_mEmpresas] PRIMARY KEY CLUSTERED 
(
	[IdEmpresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mPerEmp]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mPerEmp](
	[IdPersona] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[IdEmpresa] [tinyint] NOT NULL,
	[Persona] [int] NOT NULL,
 CONSTRAINT [PK_mPerEmp] PRIMARY KEY CLUSTERED 
(
	[IdPersona] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vPersonas_Tickets]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vPersonas_Tickets] AS
SELECT mPerEmp.IdPersona, mPerEmp.IdEmpresa,
       LTRIM(RTRIM(mPersonas.Paterno + ' ' + mPersonas.Materno + ' ' + mPersonas.Nombre)) AS Nombre, 
       mPersonas.Descripcion, mPersonas.RFC, mPersonas.Email, mPersonas.TipoPersona,
       mEmpresas.Logo
FROM mPerEmp INNER JOIN
     mPersonas ON mPerEmp.Persona = mPersonas.Persona LEFT OUTER JOIN
     mEmpresas ON mPerEmp.IdEmpresa = mEmpresas.IdEmpresa
GO
/****** Object:  View [dbo].[vNombres_Tickets]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vNombres_Tickets] AS
SELECT mPerEmp.IdPersona, mPerEmp.IdEmpresa, 
       LTRIM(RTRIM(mPersonas.Nombre + ' ' + mPersonas.Paterno + ' ' + mPersonas.Materno)) AS Nombre, 
       mPersonas.Descripcion, mPersonas.RFC, mPersonas.Email, mPersonas.TipoPersona
FROM mPersonas INNER JOIN
     mPerEmp ON mPersonas.Persona = mPerEmp.Persona 
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoleClaims]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoleClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [nvarchar](450) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](450) NOT NULL,
	[Name] [nvarchar](256) NULL,
	[NormalizedName] [nvarchar](256) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](450) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[ProviderDisplayName] [nvarchar](max) NULL,
	[UserId] [nvarchar](450) NOT NULL,
 CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](450) NOT NULL,
	[RoleId] [nvarchar](450) NOT NULL,
 CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](450) NOT NULL,
	[UserName] [nvarchar](256) NULL,
	[NormalizedUserName] [nvarchar](256) NULL,
	[Email] [nvarchar](256) NULL,
	[NormalizedEmail] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEnd] [datetimeoffset](7) NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[NombreCompleto] [nvarchar](150) NOT NULL,
	[IdDepartamento] [tinyint] NULL,
	[Activo] [bit] NOT NULL,
	[FechaRegistro] [datetime2](7) NOT NULL,
	[UltimoAcceso] [datetime2](7) NULL,
 CONSTRAINT [PK_AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserTokens]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserTokens](
	[UserId] [nvarchar](450) NOT NULL,
	[LoginProvider] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[LoginProvider] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Departamentos]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Departamentos](
	[IdDepartamento] [tinyint] IDENTITY(1,1) NOT NULL,
	[Departamento] [nvarchar](80) NOT NULL,
 CONSTRAINT [PK_Departamentos] PRIMARY KEY CLUSTERED 
(
	[IdDepartamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dTickets]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dTickets](
	[IdDTicket] [int] IDENTITY(1,1) NOT NULL,
	[IdTicket] [int] NOT NULL,
	[Evento] [nvarchar](max) NOT NULL,
	[Tiempo] [int] NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[Usuario] [nvarchar](12) NOT NULL,
 CONSTRAINT [PK_dTickets] PRIMARY KEY CLUSTERED 
(
	[IdDTicket] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[hdTickets]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hdTickets](
	[IdDTicket] [int] NOT NULL,
	[IdTicket] [int] NOT NULL,
	[Evento] [nvarchar](max) NOT NULL,
	[Tiempo] [int] NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[Usuario] [nvarchar](12) NOT NULL,
 CONSTRAINT [PK_hdTickets] PRIMARY KEY CLUSTERED 
(
	[IdDTicket] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mActivos]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mActivos](
	[IdActivo] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [nvarchar](40) NOT NULL,
	[Marca] [nvarchar](50) NULL,
	[Modelo] [nvarchar](80) NULL,
	[Serie] [nvarchar](80) NULL,
	[Nombre] [nvarchar](120) NULL,
	[PersonaAsign] [nvarchar](120) NULL,
	[Ubicacion] [nvarchar](120) NULL,
	[FeCompra] [date] NULL,
	[FeAlta] [datetime2](7) NOT NULL,
	[FeBaja] [datetime2](7) NULL,
	[CostoCompra] [decimal](12, 2) NULL,
	[Notas] [nvarchar](400) NULL,
	[IdTipoActivo] [tinyint] NULL,
	[IdDepartamento] [tinyint] NULL,
	[IdStatus] [tinyint] NULL,
	[IdProveedor] [tinyint] NULL,
	[CodificacionComponentes] [int] NULL,
	[TieneSoftwareOP] [bit] NULL,
 CONSTRAINT [PK_mActivos] PRIMARY KEY CLUSTERED 
(
	[IdActivo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mComponentes]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mComponentes](
	[IdComponente] [tinyint] IDENTITY(1,1) NOT NULL,
	[Componente] [nvarchar](80) NOT NULL,
	[ValorBit] [int] NULL,
 CONSTRAINT [PK_Componentes] PRIMARY KEY CLUSTERED 
(
	[IdComponente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mPrioridadTicket]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mPrioridadTicket](
	[IdPrioridad] [tinyint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Prioridad] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_mPrioridadTicket] PRIMARY KEY CLUSTERED 
(
	[IdPrioridad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mProveedores]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mProveedores](
	[IdProveedor] [tinyint] IDENTITY(1,1) NOT NULL,
	[Proveedor] [nvarchar](120) NOT NULL,
 CONSTRAINT [PK_Proveedores] PRIMARY KEY CLUSTERED 
(
	[IdProveedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mSoftware]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mSoftware](
	[IdSoftware] [tinyint] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](80) NOT NULL,
 CONSTRAINT [PK_Software] PRIMARY KEY CLUSTERED 
(
	[IdSoftware] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mStatus]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mStatus](
	[StatusId] [tinyint] IDENTITY(1,1) NOT NULL,
	[Status] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED 
(
	[StatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mSysVar]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mSysVar](
	[Variable] [nvarchar](20) NOT NULL,
	[Valor] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_mSysVar_1] PRIMARY KEY CLUSTERED 
(
	[Variable] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mTiposActivo]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mTiposActivo](
	[IdTipoActivo] [tinyint] IDENTITY(1,1) NOT NULL,
	[TipoActivo] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TiposActivo] PRIMARY KEY CLUSTERED 
(
	[IdTipoActivo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mTipoTicket]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mTipoTicket](
	[IdTipoTicket] [tinyint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TipoTicket] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_mTipoTicket] PRIMARY KEY CLUSTERED 
(
	[IdTipoTicket] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[mValoracionTicket]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mValoracionTicket](
	[IdTicket] [int] NOT NULL,
	[Fecha] [smalldatetime] NOT NULL,
	[Valoracion] [smallint] NULL,
	[Comentario] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[mActivos] ADD  DEFAULT (sysutcdatetime()) FOR [FeAlta]
GO
ALTER TABLE [dbo].[mDepartamentos] ADD  CONSTRAINT [DF_mDepartamentos_Tickets]  DEFAULT ((0)) FOR [Tickets]
GO
ALTER TABLE [dbo].[mEmpleados] ADD  CONSTRAINT [DF_mEmpleados_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[AspNetRoleClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetRoleClaims] CHECK CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserTokens]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserTokens] CHECK CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[dEmpleados]  WITH CHECK ADD  CONSTRAINT [FK_dEmpleados_mPuestos] FOREIGN KEY([IdPuesto])
REFERENCES [dbo].[mPuestos] ([IdPuesto])
GO
ALTER TABLE [dbo].[dEmpleados] CHECK CONSTRAINT [FK_dEmpleados_mPuestos]
GO
ALTER TABLE [dbo].[dTickets]  WITH CHECK ADD  CONSTRAINT [FK_dTicketsLog_mTickets] FOREIGN KEY([IdTicket])
REFERENCES [dbo].[mTickets] ([IdTicket])
GO
ALTER TABLE [dbo].[dTickets] CHECK CONSTRAINT [FK_dTicketsLog_mTickets]
GO
ALTER TABLE [dbo].[dTicketsTecnicos]  WITH CHECK ADD  CONSTRAINT [FK_dTicketsTecnicos_mEmpleados] FOREIGN KEY([IdPersona])
REFERENCES [dbo].[mEmpleados] ([IdPersona])
GO
ALTER TABLE [dbo].[dTicketsTecnicos] CHECK CONSTRAINT [FK_dTicketsTecnicos_mEmpleados]
GO
ALTER TABLE [dbo].[dTicketsTecnicos]  WITH CHECK ADD  CONSTRAINT [FK_dTicketsTecnicos_mTickets] FOREIGN KEY([IdTicket])
REFERENCES [dbo].[mTickets] ([IdTicket])
GO
ALTER TABLE [dbo].[dTicketsTecnicos] CHECK CONSTRAINT [FK_dTicketsTecnicos_mTickets]
GO
ALTER TABLE [dbo].[hdTickets]  WITH CHECK ADD  CONSTRAINT [FK_hdTickets_hTickets] FOREIGN KEY([IdTicket])
REFERENCES [dbo].[hTickets] ([IdTicket])
GO
ALTER TABLE [dbo].[hdTickets] CHECK CONSTRAINT [FK_hdTickets_hTickets]
GO
ALTER TABLE [dbo].[hdTicketsTecnicos]  WITH CHECK ADD  CONSTRAINT [FK_hdTicketsTecnicos_hTickets] FOREIGN KEY([IdTicket])
REFERENCES [dbo].[hTickets] ([IdTicket])
GO
ALTER TABLE [dbo].[hdTicketsTecnicos] CHECK CONSTRAINT [FK_hdTicketsTecnicos_hTickets]
GO
ALTER TABLE [dbo].[hdTicketsTecnicos]  WITH CHECK ADD  CONSTRAINT [FK_hdTicketsTecnicos_mEmpleados] FOREIGN KEY([IdPersona])
REFERENCES [dbo].[mEmpleados] ([IdPersona])
GO
ALTER TABLE [dbo].[hdTicketsTecnicos] CHECK CONSTRAINT [FK_hdTicketsTecnicos_mEmpleados]
GO
ALTER TABLE [dbo].[hTickets]  WITH CHECK ADD  CONSTRAINT [FK_hTickets_mPerEmpUsuario] FOREIGN KEY([Usuario])
REFERENCES [dbo].[mPerEmp] ([IdPersona])
GO
ALTER TABLE [dbo].[hTickets] CHECK CONSTRAINT [FK_hTickets_mPerEmpUsuario]
GO
ALTER TABLE [dbo].[hTickets]  WITH CHECK ADD  CONSTRAINT [FK_hTickets_mPrioridadTicket] FOREIGN KEY([Prioridad])
REFERENCES [dbo].[mPrioridadTicket] ([IdPrioridad])
GO
ALTER TABLE [dbo].[hTickets] CHECK CONSTRAINT [FK_hTickets_mPrioridadTicket]
GO
ALTER TABLE [dbo].[hTickets]  WITH CHECK ADD  CONSTRAINT [FK_hTickets_mSubCategoriasTicket] FOREIGN KEY([IdSubCategoria])
REFERENCES [dbo].[mSubCategoriasTicket] ([IdSubCategoria])
GO
ALTER TABLE [dbo].[hTickets] CHECK CONSTRAINT [FK_hTickets_mSubCategoriasTicket]
GO
ALTER TABLE [dbo].[hTickets]  WITH CHECK ADD  CONSTRAINT [FK_hTickets_mTipoTicket] FOREIGN KEY([IdTipoTicket])
REFERENCES [dbo].[mTipoTicket] ([IdTipoTicket])
GO
ALTER TABLE [dbo].[hTickets] CHECK CONSTRAINT [FK_hTickets_mTipoTicket]
GO
ALTER TABLE [dbo].[mActivos]  WITH CHECK ADD  CONSTRAINT [FK_mActivos_Departamentos] FOREIGN KEY([IdDepartamento])
REFERENCES [dbo].[Departamentos] ([IdDepartamento])
GO
ALTER TABLE [dbo].[mActivos] CHECK CONSTRAINT [FK_mActivos_Departamentos]
GO
ALTER TABLE [dbo].[mActivos]  WITH CHECK ADD  CONSTRAINT [FK_mActivos_Proveedores] FOREIGN KEY([IdProveedor])
REFERENCES [dbo].[mProveedores] ([IdProveedor])
GO
ALTER TABLE [dbo].[mActivos] CHECK CONSTRAINT [FK_mActivos_Proveedores]
GO
ALTER TABLE [dbo].[mActivos]  WITH CHECK ADD  CONSTRAINT [FK_mActivos_Status] FOREIGN KEY([IdStatus])
REFERENCES [dbo].[mStatus] ([StatusId])
GO
ALTER TABLE [dbo].[mActivos] CHECK CONSTRAINT [FK_mActivos_Status]
GO
ALTER TABLE [dbo].[mActivos]  WITH CHECK ADD  CONSTRAINT [FK_mActivos_TiposActivo] FOREIGN KEY([IdTipoActivo])
REFERENCES [dbo].[mTiposActivo] ([IdTipoActivo])
GO
ALTER TABLE [dbo].[mActivos] CHECK CONSTRAINT [FK_mActivos_TiposActivo]
GO
ALTER TABLE [dbo].[mCategoriasTicket]  WITH CHECK ADD  CONSTRAINT [FK_mCategoriasTicket_mDepartamentos] FOREIGN KEY([IdDepto])
REFERENCES [dbo].[mDepartamentos] ([IdDepto])
GO
ALTER TABLE [dbo].[mCategoriasTicket] CHECK CONSTRAINT [FK_mCategoriasTicket_mDepartamentos]
GO
ALTER TABLE [dbo].[mEmpresas]  WITH CHECK ADD  CONSTRAINT [FK_mEmpresas_mPersonas] FOREIGN KEY([Persona])
REFERENCES [dbo].[mPersonas] ([Persona])
GO
ALTER TABLE [dbo].[mEmpresas] CHECK CONSTRAINT [FK_mEmpresas_mPersonas]
GO
ALTER TABLE [dbo].[mPersonas]  WITH CHECK ADD  CONSTRAINT [FK_mPersonas_mPersonas] FOREIGN KEY([IdReferencia])
REFERENCES [dbo].[mPersonas] ([Persona])
GO
ALTER TABLE [dbo].[mPersonas] CHECK CONSTRAINT [FK_mPersonas_mPersonas]
GO
ALTER TABLE [dbo].[mPuestos]  WITH CHECK ADD  CONSTRAINT [FK_mPuestos_mDepartamentos] FOREIGN KEY([IdDepto])
REFERENCES [dbo].[mDepartamentos] ([IdDepto])
GO
ALTER TABLE [dbo].[mPuestos] CHECK CONSTRAINT [FK_mPuestos_mDepartamentos]
GO
ALTER TABLE [dbo].[mSubCategoriasTicket]  WITH CHECK ADD  CONSTRAINT [FK_mSubCategoriasTicket_mCategoriasTicket] FOREIGN KEY([IdCategoria])
REFERENCES [dbo].[mCategoriasTicket] ([IdCategoria])
GO
ALTER TABLE [dbo].[mSubCategoriasTicket] CHECK CONSTRAINT [FK_mSubCategoriasTicket_mCategoriasTicket]
GO
ALTER TABLE [dbo].[mTickets]  WITH CHECK ADD  CONSTRAINT [FK_mTickets_mPerEmpUsuario] FOREIGN KEY([Usuario])
REFERENCES [dbo].[mPerEmp] ([IdPersona])
GO
ALTER TABLE [dbo].[mTickets] CHECK CONSTRAINT [FK_mTickets_mPerEmpUsuario]
GO
ALTER TABLE [dbo].[mTickets]  WITH CHECK ADD  CONSTRAINT [FK_mTickets_mPrioridadTicket] FOREIGN KEY([Prioridad])
REFERENCES [dbo].[mPrioridadTicket] ([IdPrioridad])
GO
ALTER TABLE [dbo].[mTickets] CHECK CONSTRAINT [FK_mTickets_mPrioridadTicket]
GO
ALTER TABLE [dbo].[mTickets]  WITH CHECK ADD  CONSTRAINT [FK_mTickets_mStatusTicket] FOREIGN KEY([Status])
REFERENCES [dbo].[mStatusTicket] ([Status])
GO
ALTER TABLE [dbo].[mTickets] CHECK CONSTRAINT [FK_mTickets_mStatusTicket]
GO
ALTER TABLE [dbo].[mTickets]  WITH CHECK ADD  CONSTRAINT [FK_mTickets_mSubCategoriasTicket] FOREIGN KEY([IdSubCategoria])
REFERENCES [dbo].[mSubCategoriasTicket] ([IdSubCategoria])
GO
ALTER TABLE [dbo].[mTickets] CHECK CONSTRAINT [FK_mTickets_mSubCategoriasTicket]
GO
ALTER TABLE [dbo].[mTickets]  WITH CHECK ADD  CONSTRAINT [FK_mTickets_mTipoTicket] FOREIGN KEY([IdTipoTicket])
REFERENCES [dbo].[mTipoTicket] ([IdTipoTicket])
GO
ALTER TABLE [dbo].[mTickets] CHECK CONSTRAINT [FK_mTickets_mTipoTicket]
GO
/****** Object:  StoredProcedure [dbo].[TicketValoracionEnviar]    Script Date: 17/10/2025 12:08:46 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jorge Carrazco
-- Create date: 20 Septiembre 2019
-- Description:	Busca en la tabla de respuesta que no existan mas de dos registros por dia de respuestas de encuesta
-- =============================================
CREATE PROCEDURE [dbo].[TicketValoracionEnviar] 
	-- Add the parameters for the stored procedure here
	@idticket int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--Regresa el numero de encuestas respondidas en el dia
	IF (SELECT COUNT(mValoracionTicket.IdTicket) AS Respuestas 
		FROM mValoracionTicket INNER JOIN
		mTickets ON mValoracionTicket.IdTicket = mTickets.IdTicket  
		WHERE mTickets.Usuario = (Select mTickets.Usuario From mTickets Where mTickets.IdTicket = @idticket)  
		And DATEDIFF(d, mValoracionTicket.Fecha, GETDATE()) = 0) < dbo.GetSysVar('TicketNoEncuestas') 
	BEGIN
		Return 1
	END
	ELSE
	BEGIN
		Return 0
	END

END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identificador único del departamento' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Departamentos', @level2type=N'COLUMN',@level2name=N'IdDepartamento'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nombre del departamento' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Departamentos', @level2type=N'COLUMN',@level2name=N'Departamento'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identificador único del componente' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mComponentes', @level2type=N'COLUMN',@level2name=N'IdComponente'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nombre del componente' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mComponentes', @level2type=N'COLUMN',@level2name=N'Componente'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Valor bit para codificación' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mComponentes', @level2type=N'COLUMN',@level2name=N'ValorBit'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identificador único del proveedor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mProveedores', @level2type=N'COLUMN',@level2name=N'IdProveedor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nombre del proveedor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mProveedores', @level2type=N'COLUMN',@level2name=N'Proveedor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identificador único del software' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mSoftware', @level2type=N'COLUMN',@level2name=N'IdSoftware'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nombre del software' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mSoftware', @level2type=N'COLUMN',@level2name=N'Nombre'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identificador único del status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mStatus', @level2type=N'COLUMN',@level2name=N'StatusId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nombre del status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mStatus', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identificador único del tipo de activo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mTiposActivo', @level2type=N'COLUMN',@level2name=N'IdTipoActivo'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nombre del tipo de activo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'mTiposActivo', @level2type=N'COLUMN',@level2name=N'TipoActivo'
GO

------------------------------------------------------------------------------------------------------------------
----------------------------------------------------- SEEDERS -----------------------------------------------------
------------------------------------------------------------------------------------------------------------------

-- NOTA: Estos seeders son idempotentes (verifican existencia previa)

-- Variables del sistema
IF NOT EXISTS (SELECT 1 FROM [dbo].[mSysVar] WHERE [Variable] = 'TicketNoEncuestas')
BEGIN
    INSERT INTO [dbo].[mSysVar] (Variable, Valor) VALUES ('TicketNoEncuestas', '2')
END
GO

-- Catálogos de Activos
IF NOT EXISTS (SELECT 1 FROM [dbo].[mTiposActivo])
BEGIN
    INSERT INTO [dbo].[mTiposActivo] (TipoActivo)
    VALUES ('Laptop'), ('PC de Escritorio'), ('Servidor'), ('Impresora'), ('Router'), ('Monitor'), ('Tablet'), ('Smartphone'), ('Switch de Red'), ('Firewall'), ('UPS'), ('Escáner');
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[mProveedores])
BEGIN
    INSERT INTO [dbo].[mProveedores] (Proveedor)
    VALUES ('Dell Technologies'),('HP Inc.'),('Lenovo Group'),('Apple Inc.'),('Microsoft Corporation'),('ASUS Computer'),('Acer Inc.'),('Samsung Electronics'),('Canon Inc.'),('Epson Corporation'),('Cisco Systems'),('Ubiquiti Networks'),('APC by Schneider Electric'),('Brother Industries'),('Xerox Corporation');
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[mStatus])
BEGIN
    INSERT INTO [dbo].[mStatus] (Status) VALUES ('A'),('M'),('B'),('G'),('R'),('D');
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[mComponentes])
BEGIN
    INSERT INTO [dbo].[mComponentes] (Componente, ValorBit)
    VALUES ('Procesador',1),('Memoria RAM',2),('Disco Duro SSD',4),('Tarjeta Gráfica',8),('Fuente de Poder',16),('Tarjeta de Red',32),('Ventiladores',64),('Pantalla',128),('Teclado',256),('Mouse',512),('Bocinas',1024),('Cámara Web',2048),('Micrófono',4096),('Disco Duro HDD',8192);
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[mSoftware])
BEGIN
    INSERT INTO [dbo].[mSoftware] (Nombre)
    VALUES ('Windows 11 Pro'),('Windows 10 Pro'),('Windows Server 2022'),('macOS Sonoma'),('macOS Ventura'),('Ubuntu 22.04 LTS'),('Ubuntu 20.04 LTS'),('Red Hat Enterprise Linux'),('CentOS Stream'),('Microsoft Office 365'),('Microsoft Office 2021'),('Adobe Creative Cloud'),('Adobe Acrobat Pro'),('Google Workspace'),('Zoom Professional'),('Microsoft Teams'),('Slack'),('Visual Studio Professional'),('IntelliJ IDEA'),('Photoshop CC');
END
GO

-- Departamento base para Activos (tabla Departamentos)
IF NOT EXISTS (SELECT 1 FROM [dbo].[Departamentos])
BEGIN
    INSERT INTO [dbo].[Departamentos] (Departamento) VALUES ('Ventas'),('Soporte Técnico'),('Recursos Humanos'),('Finanzas'),('Marketing'),('Dirección General'),('Contabilidad'),('Sistemas'),('Almacén'),('Producción'),('Calidad'),('Compras');
END
GO

-- Activos de ejemplo (requiere catálogos previos)
IF NOT EXISTS (SELECT 1 FROM [dbo].[mActivos])
BEGIN
    INSERT INTO [dbo].[mActivos] (Codigo, Marca, Modelo, Serie, Nombre, PersonaAsign, Ubicacion, FeCompra, FeAlta, CostoCompra, Notas, IdTipoActivo, IdDepartamento, IdStatus, IdProveedor, CodificacionComponentes, TieneSoftwareOP)
    VALUES
    ('ACT-001','Dell','XPS 15','DL-XPS-001','Laptop Ejecutiva','Ana Pérez García','Dirección General - Oficina 101','2024-03-15',GETDATE(),2850.50,'Laptop de alto rendimiento para dirección general con pantalla 4K.',1,6,1,1,903,1),
    ('ACT-002','HP','ProDesk 400 G9','HP-PD-002','PC Soporte Técnico','Carlos Gómez López','Soporte Técnico - Puesto 23','2023-11-20',GETDATE(),1200.00,'Equipo estándar para el área de soporte técnico.',2,2,1,2,63,1),
    ('SRV-001','Dell','PowerEdge R740','DL-PE-001','Servidor BD Principal','María González Ruiz','Datacenter - Rack A1','2024-01-10',GETDATE(),8500.00,'Servidor principal de base de datos con alta disponibilidad.',3,8,1,1,8311,1),
    ('IMP-001','Canon','imageRUNNER ADVANCE C3330i','CN-IR-001','Impresora Multifuncional Color',NULL,'Recursos Humanos - Área común','2023-08-15',GETDATE(),3200.00,'Impresora multifuncional a color para el departamento de RRHH.',4,3,1,9,0,0),
    ('NET-001','Cisco','ISR 4331','CS-ISR-001','Router Principal','Luis Martínez Vega','Sistemas - Cuarto de comunicaciones','2023-05-20',GETDATE(),2800.00,'Router principal para conectividad de la empresa.',5,8,1,11,49,1),
    ('MON-001','ASUS','ProArt PA348CGV','AS-PA-001','Monitor Ultrawide 34"','Sandra López Morales','Marketing - Estación de diseño','2024-02-28',GETDATE(),1850.00,'Monitor ultrawide para diseño gráfico y marketing.',6,5,1,6,128,0),
    ('ACT-003','Lenovo','ThinkPad X1 Carbon','LN-X1-001','Laptop Ventas','Roberto Silva Castro','Ventas - Oficina móvil','2024-04-12',GETDATE(),2200.00,'Laptop ligera para el equipo de ventas con cámara HD.',1,1,1,3,2951,1),
    ('ACT-004','HP','EliteDesk 800 G9','HP-ED-001','PC Contabilidad','Patricia Hernández Ruiz','Contabilidad - Puesto 15','2023-09-10',GETDATE(),1100.00,'PC de escritorio para tareas contables y administrativas.',2,7,1,2,807,1),
    ('TAB-001','Samsung','Galaxy Tab S9','SM-GTS9-001','Tablet Almacén','Jorge Ramírez Torres','Almacén - Área de inventario','2024-06-05',GETDATE(),850.00,'Tablet para control de inventario con escáner integrado.',7,9,1,8,2177,1),
    ('UPS-001','APC','Smart-UPS SRT 5000VA','APC-SRT-001','UPS Sala Servidores','Miguel Ángel Díaz','Datacenter - Rack B1','2023-03-22',GETDATE(),3500.00,'UPS de respaldo para sala de servidores - En mantenimiento preventivo.',11,8,2,13,16,0);
END
GO

-- Personas / Empresa / PerEmp
IF NOT EXISTS (SELECT 1 FROM [dbo].[mPersonas])
BEGIN
    INSERT INTO [dbo].[mPersonas] (Nombre, Paterno, Materno, Descripcion, RFC, Email, TipoPersona, Usuario, FeModifica)
    VALUES ('Juan Carlos','García','López','Administrador del Sistema','GALJ800101ABC','juan.garcia@empresa.com','F','ADMIN',GETDATE()),
           ('María Elena','Rodríguez','Martínez','Gerente de TI','ROMM850215DEF','maria.rodriguez@empresa.com','F','ADMIN',GETDATE()),
           ('Carlos Alberto','Hernández','González','Técnico Senior','HEGC900310GHI','carlos.hernandez@empresa.com','F','ADMIN',GETDATE()),
           ('Ana Patricia','Sánchez','Flores','Técnico Junior','SAFA920425JKL','ana.sanchez@empresa.com','F','ADMIN',GETDATE()),
           ('Roberto','Jiménez','Vega','Usuario Final','JIVR880720MNO','roberto.jimenez@empresa.com','F','ADMIN',GETDATE()),
           ('Empresa Demo','S.A.','de C.V.','Empresa de Prueba','EDE123456789','contacto@empresademo.com','M','ADMIN',GETDATE());
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[mEmpresas])
BEGIN
    INSERT INTO [dbo].[mEmpresas] (Persona, Logo) VALUES (6, NULL);
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[mPerEmp])
BEGIN
    INSERT INTO [dbo].[mPerEmp] (IdEmpresa, Persona) VALUES (1,1),(1,2),(1,3),(1,4),(1,5);
END
GO

-- Catálogos de Tickets (mDepartamentos/mPuestos ya definidos arriba)
IF NOT EXISTS (SELECT 1 FROM [dbo].[mStatusTicket])
BEGIN
    INSERT INTO [dbo].[mStatusTicket] (StatusDes) VALUES ('Abierto'),('En Proceso'),('Cerrado');
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[mPrioridadTicket])
BEGIN
    INSERT INTO [dbo].[mPrioridadTicket] (Prioridad) VALUES ('Baja'),('Media'),('Alta');
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[mTipoTicket])
BEGIN
    INSERT INTO [dbo].[mTipoTicket] (TipoTicket) VALUES ('Requerimiento'),('Cambio'),('Incidencia'),('Soporte');
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[mCategoriasTicket])
BEGIN
    INSERT INTO [dbo].[mCategoriasTicket] (Categoria, IdDepto)
    VALUES ('Hardware',1),('Software',1),('Redes',1),('Usuarios',1),('Solicitudes RH',2),('Nómina',2),('Contabilidad',3),('Facturación',3),('Ventas',4),('CRM',4);
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[mSubCategoriasTicket])
BEGIN
    INSERT INTO [dbo].[mSubCategoriasTicket] (SubCategoria, IdCategoria)
    VALUES ('Equipos de Cómputo',1),('Impresoras',1),('Servidores',1),('Dispositivos Móviles',1),
           ('Sistema Operativo',2),('Aplicaciones',2),('Antivirus',2),('Licencias',2),
           ('Conectividad',3),('Internet',3),('Correo Electrónico',3),('Acceso Remoto',3),
           ('Accesos',4),('Contraseñas',4),('Permisos',4),('Capacitación',4),
           ('Altas',5),('Bajas',5),('Cambios',5),('Consultas',5),
           ('Cálculos',6),('Reportes',6),('Errores',6),
           ('Asientos',7),('Reportes',7),('Conciliaciones',7),
           ('Facturas',8),('Notas de Crédito',8),('Cancelaciones',8),
           ('Cotizaciones',9),('Pedidos',9),('Clientes',9),
           ('Configuración',10),('Reportes',10),('Integración',10);
END
GO

-- Empleados para Tickets
IF NOT EXISTS (SELECT 1 FROM [dbo].[mEmpleados])
BEGIN
    INSERT INTO [dbo].[mEmpleados] (IdPersona, Login, Activo) VALUES (1,'ADMIN',1),(2,'MARIA.R',1),(3,'CARLOS.H',1),(4,'ANA.S',1),(5,'ROBERTO.J',1);
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[dEmpleados])
BEGIN
    INSERT INTO [dbo].[dEmpleados] (IdPersona, IdPuesto, Principal) VALUES (1,1,1),(2,1,1),(3,3,1),(4,3,1),(5,8,1);
END
GO

-- Tickets y relaciones
IF NOT EXISTS (SELECT 1 FROM [dbo].[mTickets])
BEGIN
    INSERT INTO [dbo].[mTickets] (Usuario, IdSubCategoria, Titulo, Descripcion, Status, IdTipoTicket, Prioridad, FeAlta, FeAsignacion, FeCompromiso)
    VALUES (5,1,'Laptop no enciende','La laptop del usuario no enciende después de actualización del sistema',1,1,2,GETDATE(),NULL,DATEADD(day,2,GETDATE())),
           (5,5,'Problema con Outlook','No puede enviar correos electrónicos desde Outlook',2,1,1,DATEADD(day,-1,GETDATE()),DATEADD(day,-1,GETDATE()),DATEADD(day,1,GETDATE())),
           (5,9,'Sin acceso a Internet','No tiene conexión a Internet en su estación de trabajo',1,1,3,GETDATE(),NULL,DATEADD(day,1,GETDATE())),
           (5,13,'Solicitud de acceso','Necesita acceso al sistema de facturación',2,2,2,DATEADD(day,-2,GETDATE()),DATEADD(day,-2,GETDATE()),GETDATE()),
           (5,17,'Cambio de contraseña','Solicita cambio de contraseña de dominio',1,2,1,GETDATE(),NULL,DATEADD(day,1,GETDATE()));
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[dTicketsTecnicos])
BEGIN
    INSERT INTO [dbo].[dTicketsTecnicos] (IdTicket, IdPersona) VALUES (2,3),(4,3),(2,4);
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[dTickets])
BEGIN
    INSERT INTO [dbo].[dTickets] (IdTicket, Evento, Tiempo, Fecha, Usuario)
    VALUES (2,'Ticket asignado al técnico Carlos Hernández',0,DATEADD(day,-1,GETDATE()),'ADMIN'),
           (2,'Se realizó diagnóstico inicial del problema',30,DATEADD(day,-1,GETDATE()),'CARLOS.H'),
           (2,'Se identificó problema con configuración SMTP',45,DATEADD(day,-1,GETDATE()),'CARLOS.H'),
           (4,'Ticket asignado al técnico Carlos Hernández',0,DATEADD(day,-2,GETDATE()),'ADMIN'),
           (4,'Se verificaron permisos del usuario',20,DATEADD(day,-2,GETDATE()),'CARLOS.H'),
           (4,'Se otorgó acceso al sistema de facturación',15,DATEADD(day,-1,GETDATE()),'CARLOS.H');
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[hTickets])
BEGIN
    INSERT INTO [dbo].[hTickets] (IdTicket, Usuario, IdSubCategoria, Titulo, Descripcion, IdTipoTicket, Prioridad, FeAlta, FeAsignacion, FeCompromiso, FeCierre)
    VALUES (1001,5,6,'Problema con Excel','Excel se cierra inesperadamente',1,1,DATEADD(day,-10,GETDATE()),DATEADD(day,-10,GETDATE()),DATEADD(day,-8,GETDATE()),DATEADD(day,-8,GETDATE())),
           (1002,5,14,'Solicitud de software','Necesita instalar Adobe Acrobat',2,2,DATEADD(day,-15,GETDATE()),DATEADD(day,-15,GETDATE()),DATEADD(day,-13,GETDATE()),DATEADD(day,-13,GETDATE()));
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[hdTicketsTecnicos])
BEGIN
    INSERT INTO [dbo].[hdTicketsTecnicos] (IdTicket, IdPersona) VALUES (1001,3),(1002,4);
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[hdTickets])
BEGIN
    INSERT INTO [dbo].[hdTickets] (IdDTicket, IdTicket, Evento, Tiempo, Fecha, Usuario)
    VALUES (2001,1001,'Ticket asignado',0,DATEADD(day,-10,GETDATE()),'ADMIN'),
           (2002,1001,'Se realizó diagnóstico',30,DATEADD(day,-10,GETDATE()),'CARLOS.H'),
           (2003,1001,'Se reinstaló Excel',60,DATEADD(day,-9,GETDATE()),'CARLOS.H'),
           (2004,1001,'Ticket cerrado - Problema resuelto',0,DATEADD(day,-8,GETDATE()),'CARLOS.H'),
           (2005,1002,'Ticket asignado',0,DATEADD(day,-15,GETDATE()),'ADMIN'),
           (2006,1002,'Se verificó licencia',15,DATEADD(day,-15,GETDATE()),'ANA.S'),
           (2007,1002,'Se instaló Adobe Acrobat',45,DATEADD(day,-14,GETDATE()),'ANA.S'),
           (2008,1002,'Ticket cerrado - Software instalado',0,DATEADD(day,-13,GETDATE()),'ANA.S');
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[mValoracionTicket])
BEGIN
    INSERT INTO [dbo].[mValoracionTicket] (IdTicket, Fecha, Valoracion, Comentario)
    VALUES (1001,DATEADD(day,-7,GETDATE()),5,'Excelente atención, problema resuelto rápidamente'),
           (1002,DATEADD(day,-12,GETDATE()),4,'Buen servicio, instalación exitosa');
END
GO

-- Identity Roles (solo roles, usuarios se crean vía app si se requiere)
IF NOT EXISTS (SELECT 1 FROM [dbo].[AspNetRoles] WHERE [NormalizedName] = 'ADMINISTRADOR')
BEGIN
    INSERT INTO [dbo].[AspNetRoles] (Id, Name, NormalizedName, ConcurrencyStamp) VALUES (NEWID(),'Administrador','ADMINISTRADOR',NEWID());
END
GO
IF NOT EXISTS (SELECT 1 FROM [dbo].[AspNetRoles] WHERE [NormalizedName] = 'SUPERVISOR')
BEGIN
    INSERT INTO [dbo].[AspNetRoles] (Id, Name, NormalizedName, ConcurrencyStamp) VALUES (NEWID(),'Supervisor','SUPERVISOR',NEWID());
END
GO
IF NOT EXISTS (SELECT 1 FROM [dbo].[AspNetRoles] WHERE [NormalizedName] = 'TECNICO')
BEGIN
    INSERT INTO [dbo].[AspNetRoles] (Id, Name, NormalizedName, ConcurrencyStamp) VALUES (NEWID(),'Tecnico','TECNICO',NEWID());
END
GO
