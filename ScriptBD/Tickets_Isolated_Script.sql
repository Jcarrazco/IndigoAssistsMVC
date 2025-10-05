-- ========================================================================
-- SCRIPT AISLADO DEL SISTEMA DE TICKETS
-- Base de datos: Indigo
-- Fecha de extracción: 04/10/2025
-- 
-- Este script contiene todas las estructuras necesarias para el sistema 
-- de tickets sin datos de producción, ideal para entorno de pruebas
-- ========================================================================

USE [IndigoBasic]
GO

-- ========================================================================
-- SECCIÓN 1: FUNCIONES DEFINIDAS POR EL USUARIO
-- ========================================================================

/****** Object:  UserDefinedFunction [dbo].[GetSysVar]    Script Date: 04/10/2025 01:23:33 p. m. ******/
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

/****** Object:  UserDefinedFunction [dbo].[GetAnotacionesTecnicosTicket]    Script Date: 04/10/2025 01:23:33 p. m. ******/
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

-- ========================================================================
-- SECCIÓN 2: TABLAS MAESTRAS - CATÁLOGOS
-- ========================================================================

/****** Object:  Table [dbo].[mPersonas]    Script Date: 04/10/2025 01:23:33 p. m. ******/
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

/****** Object:  Table [dbo].[mEmpresas]    Script Date: 04/10/2025 01:23:34 p. m. ******/
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

/****** Object:  Table [dbo].[mSysVar]    Script Date: 04/10/2025 01:23:34 p. m. ******/
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

/****** Object:  Table [dbo].[mPerEmp]    Script Date: 04/10/2025 01:23:33 p. m. ******/
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

/****** Object:  Table [dbo].[mEmpleados]    Script Date: 04/10/2025 01:23:33 p. m. ******/
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

/****** Object:  Table [dbo].[mDepartamentos]    Script Date: 04/10/2025 01:23:33 p. m. ******/
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

/****** Object:  Table [dbo].[mPuestos]    Script Date: 04/10/2025 01:23:33 p. m. ******/
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

/****** Object:  Table [dbo].[mStatusTicket]    Script Date: 04/10/2025 01:23:33 p. m. ******/
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

/****** Object:  Table [dbo].[mPrioridadTicket]    Script Date: 04/10/2025 01:23:34 p. m. ******/
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

/****** Object:  Table [dbo].[mTipoTicket]    Script Date: 04/10/2025 01:23:34 p. m. ******/
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

/****** Object:  Table [dbo].[mCategoriasTicket]    Script Date: 04/10/2025 01:23:33 p. m. ******/
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

/****** Object:  Table [dbo].[mSubCategoriasTicket]    Script Date: 04/10/2025 01:23:33 p. m. ******/
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

-- ========================================================================
-- SECCIÓN 3: TABLA PRINCIPAL - TICKETS
-- ========================================================================

/****** Object:  Table [dbo].[mTickets]    Script Date: 04/10/2025 01:23:33 p. m. ******/
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

-- ========================================================================
-- SECCIÓN 4: TABLAS DE DETALLE
-- ========================================================================

/****** Object:  Table [dbo].[dEmpleados]    Script Date: 04/10/2025 01:23:33 p. m. ******/
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

/****** Object:  Table [dbo].[dTickets]    Script Date: 04/10/2025 01:23:33 p. m. ******/
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

/****** Object:  Table [dbo].[dTicketsTecnicos]    Script Date: 04/10/2025 01:23:33 p. m. ******/
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

/****** Object:  Table [dbo].[mValoracionTicket]    Script Date: 04/10/2025 01:23:34 p. m. ******/
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

-- ========================================================================
-- SECCIÓN 5: TABLAS HISTÓRICAS
-- ========================================================================

/****** Object:  Table [dbo].[hTickets]    Script Date: 04/10/2025 01:23:33 p. m. ******/
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

/****** Object:  Table [dbo].[hdTickets]    Script Date: 04/10/2025 01:23:33 p. m. ******/
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

/****** Object:  Table [dbo].[hdTicketsTecnicos]    Script Date: 04/10/2025 01:23:33 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hdTicketsTecnicos](
	[IdTicket] [int] NOT NULL,
	[IdPersona] [int] NOT NULL
) ON [PRIMARY]
GO

-- ========================================================================
-- SECCIÓN 6: VISTAS
-- ========================================================================

/****** Object:  View [dbo].[vNombres_Tickets]    Script Date: 04/10/2025 01:23:33 p. m. ******/
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

/****** Object:  View [dbo].[vPersonas_Tickets]    Script Date: 04/10/2025 01:23:33 p. m. ******/
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

/****** Object:  View [dbo].[vEmpleados]    Script Date: 04/10/2025 01:23:33 p. m. ******/
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

/****** Object:  View [dbo].[vTickets]    Script Date: 04/10/2025 01:23:33 p. m. ******/
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

/****** Object:  View [dbo].[vhTickets]    Script Date: 04/10/2025 01:23:33 p. m. ******/
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

-- ========================================================================
-- SECCIÓN 7: DEFAULTS Y CONSTRAINTS
-- ========================================================================

ALTER TABLE [dbo].[mDepartamentos] ADD  CONSTRAINT [DF_mDepartamentos_Tickets]  DEFAULT ((0)) FOR [Tickets]
GO

ALTER TABLE [dbo].[mEmpleados] ADD  CONSTRAINT [DF_mEmpleados_Activo]  DEFAULT ((1)) FOR [Activo]
GO

-- ========================================================================
-- SECCIÓN 8: FOREIGN KEYS - RELACIONES
-- ========================================================================

-- Relaciones de mEmpresas
ALTER TABLE [dbo].[mEmpresas]  WITH CHECK ADD  CONSTRAINT [FK_mEmpresas_mPersonas] FOREIGN KEY([Persona])
REFERENCES [dbo].[mPersonas] ([Persona])
GO
ALTER TABLE [dbo].[mEmpresas] CHECK CONSTRAINT [FK_mEmpresas_mPersonas]
GO

-- Relaciones de mPersonas (auto-referencia)
ALTER TABLE [dbo].[mPersonas]  WITH CHECK ADD  CONSTRAINT [FK_mPersonas_mPersonas] FOREIGN KEY([IdReferencia])
REFERENCES [dbo].[mPersonas] ([Persona])
GO
ALTER TABLE [dbo].[mPersonas] CHECK CONSTRAINT [FK_mPersonas_mPersonas]
GO

-- Relaciones de dEmpleados
ALTER TABLE [dbo].[dEmpleados]  WITH CHECK ADD  CONSTRAINT [FK_dEmpleados_mPuestos] FOREIGN KEY([IdPuesto])
REFERENCES [dbo].[mPuestos] ([IdPuesto])
GO
ALTER TABLE [dbo].[dEmpleados] CHECK CONSTRAINT [FK_dEmpleados_mPuestos]
GO

-- Relaciones de dTickets
ALTER TABLE [dbo].[dTickets]  WITH CHECK ADD  CONSTRAINT [FK_dTicketsLog_mTickets] FOREIGN KEY([IdTicket])
REFERENCES [dbo].[mTickets] ([IdTicket])
GO
ALTER TABLE [dbo].[dTickets] CHECK CONSTRAINT [FK_dTicketsLog_mTickets]
GO

-- Relaciones de dTicketsTecnicos
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

-- Relaciones de hdTickets (históricos)
ALTER TABLE [dbo].[hdTickets]  WITH CHECK ADD  CONSTRAINT [FK_hdTickets_hTickets] FOREIGN KEY([IdTicket])
REFERENCES [dbo].[hTickets] ([IdTicket])
GO
ALTER TABLE [dbo].[hdTickets] CHECK CONSTRAINT [FK_hdTickets_hTickets]
GO

-- Relaciones de hdTicketsTecnicos (históricos)
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

-- Relaciones de hTickets
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

-- Relaciones de mCategoriasTicket
ALTER TABLE [dbo].[mCategoriasTicket]  WITH CHECK ADD  CONSTRAINT [FK_mCategoriasTicket_mDepartamentos] FOREIGN KEY([IdDepto])
REFERENCES [dbo].[mDepartamentos] ([IdDepto])
GO
ALTER TABLE [dbo].[mCategoriasTicket] CHECK CONSTRAINT [FK_mCategoriasTicket_mDepartamentos]
GO

-- Relaciones de mPuestos
ALTER TABLE [dbo].[mPuestos]  WITH CHECK ADD  CONSTRAINT [FK_mPuestos_mDepartamentos] FOREIGN KEY([IdDepto])
REFERENCES [dbo].[mDepartamentos] ([IdDepto])
GO
ALTER TABLE [dbo].[mPuestos] CHECK CONSTRAINT [FK_mPuestos_mDepartamentos]
GO

-- Relaciones de mSubCategoriasTicket
ALTER TABLE [dbo].[mSubCategoriasTicket]  WITH CHECK ADD  CONSTRAINT [FK_mSubCategoriasTicket_mCategoriasTicket] FOREIGN KEY([IdCategoria])
REFERENCES [dbo].[mCategoriasTicket] ([IdCategoria])
GO
ALTER TABLE [dbo].[mSubCategoriasTicket] CHECK CONSTRAINT [FK_mSubCategoriasTicket_mCategoriasTicket]
GO

-- Relaciones de mTickets
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

-- ========================================================================
-- SECCIÓN 9: STORED PROCEDURES
-- ========================================================================

/****** Object:  StoredProcedure [dbo].[TicketValoracionEnviar]    Script Date: 04/10/2025 01:23:35 p. m. ******/
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

-- ========================================================================
-- SECCIÓN 10: SEEDERS - DATOS DE PRUEBA
-- ========================================================================

-- Variables del Sistema
INSERT mSysVar (Variable, Valor) 
VALUES 
('TicketNoEncuestas', '2')
GO

-- Personas de Prueba
INSERT mPersonas (Nombre, Paterno, Materno, Descripcion, RFC, Email, TipoPersona, Usuario, FeModifica)
VALUES 
('Juan Carlos', 'García', 'López', 'Administrador del Sistema', 'GALJ800101ABC', 'juan.garcia@empresa.com', 'F', 'ADMIN', GETDATE()),
('María Elena', 'Rodríguez', 'Martínez', 'Gerente de TI', 'ROMM850215DEF', 'maria.rodriguez@empresa.com', 'F', 'ADMIN', GETDATE()),
('Carlos Alberto', 'Hernández', 'González', 'Técnico Senior', 'HEGC900310GHI', 'carlos.hernandez@empresa.com', 'F', 'ADMIN', GETDATE()),
('Ana Patricia', 'Sánchez', 'Flores', 'Técnico Junior', 'SAFA920425JKL', 'ana.sanchez@empresa.com', 'F', 'ADMIN', GETDATE()),
('Roberto', 'Jiménez', 'Vega', 'Usuario Final', 'JIVR880720MNO', 'roberto.jimenez@empresa.com', 'F', 'ADMIN', GETDATE()),
('Empresa Demo', 'S.A.', 'de C.V.', 'Empresa de Prueba', 'EDE123456789', 'contacto@empresademo.com', 'M', 'ADMIN', GETDATE());
GO

-- Empresas de Prueba
INSERT mEmpresas (Persona, Logo)
VALUES 
(6, NULL); -- Empresa Demo
GO

-- Departamentos
INSERT mDepartamentos (Departamento, Tickets)
VALUES 
('Sistemas', 1),
('Recursos Humanos', 1),
('Contabilidad', 1),
('Ventas', 1),
('Almacén', 0);
GO

-- Puestos
INSERT mPuestos (Puesto, IdDepto)
VALUES 
('Gerente de Sistemas', 1),
('Analista de Sistemas', 1),
('Técnico de Soporte', 1),
('Gerente de RH', 2),
('Especialista en RH', 2),
('Contador', 3),
('Auxiliar Contable', 3),
('Gerente de Ventas', 4),
('Ejecutivo de Ventas', 4),
('Supervisor de Almacén', 5),
('Operador de Almacén', 5);
GO

-- Empleados
INSERT mEmpleados (IdPersona, Login, Activo)
VALUES 
(1, 'ADMIN', 1),
(2, 'MARIA.R', 1),
(3, 'CARLOS.H', 1),
(4, 'ANA.S', 1),
(5, 'ROBERTO.J', 1);
GO

-- Relación Persona-Empresa
INSERT mPerEmp (IdEmpresa, Persona)
VALUES 
(1, 1), -- Juan Carlos - Empresa Demo
(1, 2), -- María Elena - Empresa Demo
(1, 3), -- Carlos Alberto - Empresa Demo
(1, 4), -- Ana Patricia - Empresa Demo
(1, 5); -- Roberto - Empresa Demo
GO

-- Relación Empleados-Puestos
INSERT dEmpleados (IdPersona, IdPuesto, Principal)
VALUES 
(1, 1, 1), -- Juan Carlos - Gerente de Sistemas
(2, 1, 1), -- María Elena - Gerente de Sistemas (co-gerente)
(3, 3, 1), -- Carlos Alberto - Técnico de Soporte
(4, 3, 1), -- Ana Patricia - Técnico de Soporte
(5, 8, 1); -- Roberto - Gerente de Ventas
GO

-- Estados de Tickets
INSERT mStatusTicket (StatusDes)
VALUES 
('Abierto'),
('En Proceso'),
('Cerrado');
GO

-- Prioridades de Tickets
INSERT mPrioridadTicket (Prioridad)
VALUES 
('Baja'),
('Media'),
('Alta');
GO

-- Tipos de Tickets
INSERT mTipoTicket (TipoTicket)
VALUES 
('Requerimiento'),
('Cambio'),
('Incidencia'),
('Soporte');
GO

-- Categorías de Tickets
INSERT mCategoriasTicket (Categoria, IdDepto)
VALUES 
('Hardware', 1),
('Software', 1),
('Redes', 1),
('Usuarios', 1),
('Solicitudes RH', 2),
('Nómina', 2),
('Contabilidad', 3),
('Facturación', 3),
('Ventas', 4),
('CRM', 4);
GO

-- Subcategorías de Tickets
INSERT mSubCategoriasTicket (SubCategoria, IdCategoria)
VALUES 
-- Hardware
('Equipos de Cómputo', 1),
('Impresoras', 1),
('Servidores', 1),
('Dispositivos Móviles', 1),
-- Software
('Sistema Operativo', 2),
('Aplicaciones', 2),
('Antivirus', 2),
('Licencias', 2),
-- Redes
('Conectividad', 3),
('Internet', 3),
('Correo Electrónico', 3),
('Acceso Remoto', 3),
-- Usuarios
('Accesos', 4),
('Contraseñas', 4),
('Permisos', 4),
('Capacitación', 4),
-- Solicitudes RH
('Altas', 5),
('Bajas', 5),
('Cambios', 5),
('Consultas', 5),
-- Nómina
('Cálculos', 6),
('Reportes', 6),
('Errores', 6),
-- Contabilidad
('Asientos', 7),
('Reportes', 7),
('Conciliaciones', 7),
-- Facturación
('Facturas', 8),
('Notas de Crédito', 8),
('Cancelaciones', 8),
-- Ventas
('Cotizaciones', 9),
('Pedidos', 9),
('Clientes', 9),
-- CRM
('Configuración', 10),
('Reportes', 10),
('Integración', 10);
GO

-- Tickets de Prueba
INSERT mTickets (Usuario, IdSubCategoria, Titulo, Descripcion, Status, IdTipoTicket, Prioridad, FeAlta, FeAsignacion, FeCompromiso)
VALUES 
(5, 1, 'Laptop no enciende', 'La laptop del usuario no enciende después de actualización del sistema', 1, 1, 2, GETDATE(), NULL, DATEADD(day, 2, GETDATE())),
(5, 5, 'Problema con Outlook', 'No puede enviar correos electrónicos desde Outlook', 2, 1, 1, DATEADD(day, -1, GETDATE()), DATEADD(day, -1, GETDATE()), DATEADD(day, 1, GETDATE())),
(5, 9, 'Sin acceso a Internet', 'No tiene conexión a Internet en su estación de trabajo', 1, 1, 3, GETDATE(), NULL, DATEADD(day, 1, GETDATE())),
(5, 13, 'Solicitud de acceso', 'Necesita acceso al sistema de facturación', 2, 2, 2, DATEADD(day, -2, GETDATE()), DATEADD(day, -2, GETDATE()), GETDATE()),
(5, 17, 'Cambio de contraseña', 'Solicita cambio de contraseña de dominio', 1, 2, 1, GETDATE(), NULL, DATEADD(day, 1, GETDATE()));
GO

-- Asignación de Técnicos a Tickets
INSERT dTicketsTecnicos (IdTicket, IdPersona)
VALUES 
(2, 3), -- Carlos Alberto asignado al ticket 2
(4, 3), -- Carlos Alberto asignado al ticket 4
(2, 4); -- Ana Patricia también asignada al ticket 2
GO

-- Eventos de Tickets (Log)
INSERT dTickets (IdTicket, Evento, Tiempo, Fecha, Usuario)
VALUES 
(2, 'Ticket asignado al técnico Carlos Hernández', 0, DATEADD(day, -1, GETDATE()), 'ADMIN'),
(2, 'Se realizó diagnóstico inicial del problema', 30, DATEADD(day, -1, GETDATE()), 'CARLOS.H'),
(2, 'Se identificó problema con configuración SMTP', 45, DATEADD(day, -1, GETDATE()), 'CARLOS.H'),
(4, 'Ticket asignado al técnico Carlos Hernández', 0, DATEADD(day, -2, GETDATE()), 'ADMIN'),
(4, 'Se verificaron permisos del usuario', 20, DATEADD(day, -2, GETDATE()), 'CARLOS.H'),
(4, 'Se otorgó acceso al sistema de facturación', 15, DATEADD(day, -1, GETDATE()), 'CARLOS.H');
GO

-- Tickets Históricos (Cerrados)
INSERT hTickets (IdTicket, Usuario, IdSubCategoria, Titulo, Descripcion, IdTipoTicket, Prioridad, FeAlta, FeAsignacion, FeCompromiso, FeCierre)
VALUES 
(1001, 5, 6, 'Problema con Excel', 'Excel se cierra inesperadamente', 1, 1, DATEADD(day, -10, GETDATE()), DATEADD(day, -10, GETDATE()), DATEADD(day, -8, GETDATE()), DATEADD(day, -8, GETDATE())),
(1002, 5, 14, 'Solicitud de software', 'Necesita instalar Adobe Acrobat', 2, 2, DATEADD(day, -15, GETDATE()), DATEADD(day, -15, GETDATE()), DATEADD(day, -13, GETDATE()), DATEADD(day, -13, GETDATE()));
GO

-- Técnicos Históricos
INSERT hdTicketsTecnicos (IdTicket, IdPersona)
VALUES 
(1001, 3), -- Carlos Alberto atendió ticket 1001
(1002, 4); -- Ana Patricia atendió ticket 1002
GO

-- Eventos Históricos
INSERT hdTickets (IdDTicket, IdTicket, Evento, Tiempo, Fecha, Usuario)
VALUES 
(2001, 1001, 'Ticket asignado', 0, DATEADD(day, -10, GETDATE()), 'ADMIN'),
(2002, 1001, 'Se realizó diagnóstico', 30, DATEADD(day, -10, GETDATE()), 'CARLOS.H'),
(2003, 1001, 'Se reinstaló Excel', 60, DATEADD(day, -9, GETDATE()), 'CARLOS.H'),
(2004, 1001, 'Ticket cerrado - Problema resuelto', 0, DATEADD(day, -8, GETDATE()), 'CARLOS.H'),
(2005, 1002, 'Ticket asignado', 0, DATEADD(day, -15, GETDATE()), 'ADMIN'),
(2006, 1002, 'Se verificó licencia', 15, DATEADD(day, -15, GETDATE()), 'ANA.S'),
(2007, 1002, 'Se instaló Adobe Acrobat', 45, DATEADD(day, -14, GETDATE()), 'ANA.S'),
(2008, 1002, 'Ticket cerrado - Software instalado', 0, DATEADD(day, -13, GETDATE()), 'ANA.S');
GO

-- Valoraciones de Tickets Históricos
INSERT mValoracionTicket (IdTicket, Fecha, Valoracion, Comentario)
VALUES 
(1001, DATEADD(day, -7, GETDATE()), 5, 'Excelente atención, problema resuelto rápidamente'),
(1002, DATEADD(day, -12, GETDATE()), 4, 'Buen servicio, instalación exitosa');
GO


-- ========================================================================
-- FIN DEL SCRIPT AISLADO DEL SISTEMA DE TICKETS
-- ========================================================================
-- 
-- NOTAS IMPORTANTES:
-- 
-- 1. Este script incluye todas las tablas relacionadas con el sistema de tickets
-- 2. Se incluyen las tablas históricas (hTickets, hdTickets, hdTicketsTecnicos)
-- 3. Se incluyen todas las vistas relacionadas (vTickets, vhTickets, vEmpleados)
-- 4. Se incluyen las foreign keys y constraints necesarias
-- 5. Se incluyen las funciones y stored procedures relacionados
-- 
-- DEPENDENCIAS INCLUIDAS:
-- - mPersonas: Tabla base de personas (física/moral)
-- - mEmpresas: Tabla de empresas (relacionada con mPersonas)
-- - mSysVar: Variables del sistema
-- - GetSysVar(): Función para obtener variables del sistema
-- 
-- NOTA: El stored procedure AcuseFirmaTicket no está directamente relacionado 
-- con el sistema de tickets (solo usa el término "Ticket" en su nombre)
-- 
-- TABLAS INCLUIDAS:
-- Base: mPersonas, mEmpresas, mSysVar
-- Maestras: mPerEmp, mEmpleados, mDepartamentos, mPuestos, mStatusTicket,
--           mPrioridadTicket, mTipoTicket, mCategoriasTicket, mSubCategoriasTicket
-- Principal: mTickets
-- Detalles: dEmpleados, dTickets, dTicketsTecnicos, mValoracionTicket
-- Históricas: hTickets, hdTickets, hdTicketsTecnicos
-- 
-- VISTAS INCLUIDAS:
-- vNombres, vPersonas, vEmpleados, vTickets, vhTickets
-- 
-- FUNCIONES INCLUIDAS:
-- GetSysVar, GetAnotacionesTecnicosTicket
-- 
-- STORED PROCEDURES INCLUIDOS:
-- TicketValoracionEnviar
-- 
-- SEEDERS INCLUIDOS:
-- - Variables del sistema (4 variables)
-- - Personas de prueba (6 personas: 5 empleados + 1 empresa)
-- - Empresa de prueba (1 empresa)
-- - Departamentos (5 departamentos)
-- - Puestos (11 puestos)
-- - Empleados (5 empleados con logins)
-- - Relación Persona-Empresa (5 relaciones)
-- - Relación Empleados-Puestos (5 relaciones)
-- - Estados de tickets (4 estados)
-- - Prioridades (4 prioridades)
-- - Tipos de tickets (4 tipos)
-- - Categorías (10 categorías)
-- - Subcategorías (30 subcategorías)
-- - Tickets de prueba (5 tickets activos)
-- - Asignaciones de técnicos (3 asignaciones)
-- - Eventos de tickets (6 eventos)
-- - Tickets históricos (2 tickets cerrados)
-- - Técnicos históricos (2 asignaciones históricas)
-- - Eventos históricos (8 eventos históricos)
-- - Valoraciones (2 valoraciones)
-- 
-- DATOS DE PRUEBA INCLUIDOS:
-- - 5 usuarios del sistema (ADMIN, MARIA.R, CARLOS.H, ANA.S, ROBERTO.J)
-- - 5 tickets activos con diferentes estados y prioridades
-- - 2 tickets históricos cerrados con valoraciones
-- - Estructura completa de departamentos y categorías
-- - Configuración del sistema lista para usar
-- 
-- ========================================================================

