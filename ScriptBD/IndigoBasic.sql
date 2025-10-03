USE [IndigoBasic]
GO
/****** Object:  Table [dbo].[Componentes]    Script Date: 20/09/2025 01:57:08 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Componentes](
	[IdComponente] [tinyint] IDENTITY(1,1) NOT NULL,
	[Componente] [nvarchar](80) NOT NULL,
	[ValorBit] [int] NULL,
 CONSTRAINT [PK_Componentes] PRIMARY KEY CLUSTERED 
(
	[IdComponente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Departamentos]    Script Date: 20/09/2025 01:57:08 p. m. ******/
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
/****** Object:  Table [dbo].[mActivos]    Script Date: 20/09/2025 01:57:08 p. m. ******/
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
/****** Object:  Table [dbo].[Proveedores]    Script Date: 20/09/2025 01:57:08 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Proveedores](
	[IdProveedor] [tinyint] IDENTITY(1,1) NOT NULL,
	[Proveedor] [nvarchar](120) NOT NULL,
 CONSTRAINT [PK_Proveedores] PRIMARY KEY CLUSTERED 
(
	[IdProveedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Software]    Script Date: 20/09/2025 01:57:08 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Software](
	[IdSoftware] [tinyint] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](80) NOT NULL,
 CONSTRAINT [PK_Software] PRIMARY KEY CLUSTERED 
(
	[IdSoftware] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Status]    Script Date: 20/09/2025 01:57:08 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Status](
	[StatusId] [tinyint] IDENTITY(1,1) NOT NULL,
	[Status] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED 
(
	[StatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TiposActivo]    Script Date: 20/09/2025 01:57:08 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TiposActivo](
	[IdTipoActivo] [tinyint] IDENTITY(1,1) NOT NULL,
	[TipoActivo] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TiposActivo] PRIMARY KEY CLUSTERED 
(
	[IdTipoActivo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[mActivos] ADD  DEFAULT (sysutcdatetime()) FOR [FeAlta]
GO
ALTER TABLE [dbo].[mActivos]  WITH CHECK ADD  CONSTRAINT [FK_mActivos_Departamentos] FOREIGN KEY([IdDepartamento])
REFERENCES [dbo].[Departamentos] ([IdDepartamento])
GO
ALTER TABLE [dbo].[mActivos] CHECK CONSTRAINT [FK_mActivos_Departamentos]
GO
ALTER TABLE [dbo].[mActivos]  WITH CHECK ADD  CONSTRAINT [FK_mActivos_Proveedores] FOREIGN KEY([IdProveedor])
REFERENCES [dbo].[Proveedores] ([IdProveedor])
GO
ALTER TABLE [dbo].[mActivos] CHECK CONSTRAINT [FK_mActivos_Proveedores]
GO
ALTER TABLE [dbo].[mActivos]  WITH CHECK ADD  CONSTRAINT [FK_mActivos_Status] FOREIGN KEY([IdStatus])
REFERENCES [dbo].[Status] ([StatusId])
GO
ALTER TABLE [dbo].[mActivos] CHECK CONSTRAINT [FK_mActivos_Status]
GO
ALTER TABLE [dbo].[mActivos]  WITH CHECK ADD  CONSTRAINT [FK_mActivos_TiposActivo] FOREIGN KEY([IdTipoActivo])
REFERENCES [dbo].[TiposActivo] ([IdTipoActivo])
GO
ALTER TABLE [dbo].[mActivos] CHECK CONSTRAINT [FK_mActivos_TiposActivo]
GO
------------------------------------------------------------------------------------------------------------------
-------------------------------------------------SEEDER-----------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-- Insertar datos en la tabla de Tipos de Activo
INSERT INTO [dbo].[TiposActivo] ([TipoActivo])
VALUES
('Laptop'),
('PC de Escritorio'),
('Servidor'),
('Impresora'),
('Router'),
('Monitor'),
('Tablet'),
('Smartphone'),
('Switch de Red'),
('Firewall'),
('UPS'),
('Escáner');
GO

-- Insertar datos en la tabla de Departamentos
INSERT INTO [dbo].[Departamentos] ([Departamento])
VALUES
('Ventas'),
('Soporte Técnico'),
('Recursos Humanos'),
('Finanzas'),
('Marketing'),
('Dirección General'),
('Contabilidad'),
('Sistemas'),
('Almacén'),
('Producción'),
('Calidad'),
('Compras');
GO

-- Insertar datos en la tabla de Proveedores
INSERT INTO [dbo].[Proveedores] ([Proveedor])
VALUES
('Dell Technologies'),
('HP Inc.'),
('Lenovo Group'),
('Apple Inc.'),
('Microsoft Corporation'),
('ASUS Computer'),
('Acer Inc.'),
('Samsung Electronics'),
('Canon Inc.'),
('Epson Corporation'),
('Cisco Systems'),
('Ubiquiti Networks'),
('APC by Schneider Electric'),
('Brother Industries'),
('Xerox Corporation');
GO

-- Insertar datos en la tabla de Status
INSERT INTO [dbo].[Status] ([Status])
VALUES
('A'), -- Activo
('M'), -- En Mantenimiento
('B'), -- Baja
('G'), -- En Garantía
('R'), -- En Reparación
('D'); -- Disponible
GO

-- Insertar datos en la tabla de Componentes
-- Aquí asignamos los valores de bit, que son potencias de 2
INSERT INTO [dbo].[Componentes] ([Componente], [ValorBit])
VALUES
('Procesador', 1),
('Memoria RAM', 2),
('Disco Duro SSD', 4),
('Tarjeta Gráfica', 8),
('Fuente de Poder', 16),
('Tarjeta de Red', 32),
('Ventiladores', 64),
('Pantalla', 128),
('Teclado', 256),
('Mouse', 512),
('Bocinas', 1024),
('Cámara Web', 2048),
('Micrófono', 4096),
('Disco Duro HDD', 8192);
GO

-- Insertar datos en la tabla de Software
INSERT INTO [dbo].[Software] ([Nombre])
VALUES
('Windows 11 Pro'),
('Windows 10 Pro'),
('Windows Server 2022'),
('macOS Sonoma'),
('macOS Ventura'),
('Ubuntu 22.04 LTS'),
('Ubuntu 20.04 LTS'),
('Red Hat Enterprise Linux'),
('CentOS Stream'),
('Microsoft Office 365'),
('Microsoft Office 2021'),
('Adobe Creative Cloud'),
('Adobe Acrobat Pro'),
('Google Workspace'),
('Zoom Professional'),
('Microsoft Teams'),
('Slack'),
('Visual Studio Professional'),
('IntelliJ IDEA'),
('Photoshop CC');
GO

-- Seeder para la tabla mActivos

-- Registro 1: Laptop de Gerencia
-- Componentes: Procesador(1) + Memoria RAM(2) + SSD(4) + Pantalla(128) + Teclado(256) + Mouse(512) = 903
INSERT INTO [dbo].[mActivos]
    ([Codigo], [Marca], [Modelo], [Serie], [Nombre], [PersonaAsign], [Ubicacion], [FeCompra], [FeAlta], [CostoCompra], [Notas], [IdTipoActivo], [IdDepartamento], [IdStatus], [IdProveedor], [CodificacionComponentes], [TieneSoftwareOP])
VALUES
    ('ACT-001', 'Dell', 'XPS 15', 'DL-XPS-001', 'Laptop Ejecutiva', 'Ana Pérez García', 'Dirección General - Oficina 101', '2024-03-15', GETDATE(), 2850.50, 'Laptop de alto rendimiento para dirección general con pantalla 4K.', 1, 6, 1, 1, 903, 1);
GO

-- Registro 2: PC de Soporte Técnico
-- Componentes: Procesador(1) + RAM(2) + SSD(4) + Tarjeta Gráfica(8) + Fuente(16) + Red(32) = 63
INSERT INTO [dbo].[mActivos]
    ([Codigo], [Marca], [Modelo], [Serie], [Nombre], [PersonaAsign], [Ubicacion], [FeCompra], [FeAlta], [CostoCompra], [Notas], [IdTipoActivo], [IdDepartamento], [IdStatus], [IdProveedor], [CodificacionComponentes], [TieneSoftwareOP])
VALUES
    ('ACT-002', 'HP', 'ProDesk 400 G9', 'HP-PD-002', 'PC Soporte Técnico', 'Carlos Gómez López', 'Soporte Técnico - Puesto 23', '2023-11-20', GETDATE(), 1200.00, 'Equipo estándar para el área de soporte técnico.', 2, 2, 1, 2, 63, 1);
GO

-- Registro 3: Servidor de Base de Datos
-- Componentes: Procesador(1) + RAM(2) + SSD(4) + HDD(8192) + Fuente(16) + Red(32) + Ventiladores(64) = 8311
INSERT INTO [dbo].[mActivos]
    ([Codigo], [Marca], [Modelo], [Serie], [Nombre], [PersonaAsign], [Ubicacion], [FeCompra], [FeAlta], [CostoCompra], [Notas], [IdTipoActivo], [IdDepartamento], [IdStatus], [IdProveedor], [CodificacionComponentes], [TieneSoftwareOP])
VALUES
    ('SRV-001', 'Dell', 'PowerEdge R740', 'DL-PE-001', 'Servidor BD Principal', 'María González Ruiz', 'Datacenter - Rack A1', '2024-01-10', GETDATE(), 8500.00, 'Servidor principal de base de datos con alta disponibilidad.', 3, 8, 1, 1, 8311, 1);
GO

-- Registro 4: Impresora Multifuncional
-- Sin componentes específicos (0)
INSERT INTO [dbo].[mActivos]
    ([Codigo], [Marca], [Modelo], [Serie], [Nombre], [PersonaAsign], [Ubicacion], [FeCompra], [FeAlta], [CostoCompra], [Notas], [IdTipoActivo], [IdDepartamento], [IdStatus], [IdProveedor], [CodificacionComponentes], [TieneSoftwareOP])
VALUES
    ('IMP-001', 'Canon', 'imageRUNNER ADVANCE C3330i', 'CN-IR-001', 'Impresora Multifuncional Color', NULL, 'Recursos Humanos - Área común', '2023-08-15', GETDATE(), 3200.00, 'Impresora multifuncional a color para el departamento de RRHH.', 4, 3, 1, 9, 0, 0);
GO

-- Registro 5: Router Principal
-- Componentes: Procesador(1) + Red(32) + Fuente(16) = 49
INSERT INTO [dbo].[mActivos]
    ([Codigo], [Marca], [Modelo], [Serie], [Nombre], [PersonaAsign], [Ubicacion], [FeCompra], [FeAlta], [CostoCompra], [Notas], [IdTipoActivo], [IdDepartamento], [IdStatus], [IdProveedor], [CodificacionComponentes], [TieneSoftwareOP])
VALUES
    ('NET-001', 'Cisco', 'ISR 4331', 'CS-ISR-001', 'Router Principal', 'Luis Martínez Vega', 'Sistemas - Cuarto de comunicaciones', '2023-05-20', GETDATE(), 2800.00, 'Router principal para conectividad de la empresa.', 5, 8, 1, 11, 49, 1);
GO

-- Registro 6: Monitor para Diseño
-- Componentes: Pantalla(128) solamente
INSERT INTO [dbo].[mActivos]
    ([Codigo], [Marca], [Modelo], [Serie], [Nombre], [PersonaAsign], [Ubicacion], [FeCompra], [FeAlta], [CostoCompra], [Notas], [IdTipoActivo], [IdDepartamento], [IdStatus], [IdProveedor], [CodificacionComponentes], [TieneSoftwareOP])
VALUES
    ('MON-001', 'ASUS', 'ProArt PA348CGV', 'AS-PA-001', 'Monitor Ultrawide 34"', 'Sandra López Morales', 'Marketing - Estación de diseño', '2024-02-28', GETDATE(), 1850.00, 'Monitor ultrawide para diseño gráfico y marketing.', 6, 5, 1, 6, 128, 0);
GO

-- Registro 7: Laptop para Ventas
-- Componentes: Procesador(1) + RAM(2) + SSD(4) + Pantalla(128) + Teclado(256) + Mouse(512) + Cámara(2048) = 2951
INSERT INTO [dbo].[mActivos]
    ([Codigo], [Marca], [Modelo], [Serie], [Nombre], [PersonaAsign], [Ubicacion], [FeCompra], [FeAlta], [CostoCompra], [Notas], [IdTipoActivo], [IdDepartamento], [IdStatus], [IdProveedor], [CodificacionComponentes], [TieneSoftwareOP])
VALUES
    ('ACT-003', 'Lenovo', 'ThinkPad X1 Carbon', 'LN-X1-001', 'Laptop Ventas', 'Roberto Silva Castro', 'Ventas - Oficina móvil', '2024-04-12', GETDATE(), 2200.00, 'Laptop ligera para el equipo de ventas con cámara HD.', 1, 1, 1, 3, 2951, 1);
GO

-- Registro 8: PC Contabilidad
-- Componentes: Procesador(1) + RAM(2) + SSD(4) + Red(32) + Teclado(256) + Mouse(512) = 807
INSERT INTO [dbo].[mActivos]
    ([Codigo], [Marca], [Modelo], [Serie], [Nombre], [PersonaAsign], [Ubicacion], [FeCompra], [FeAlta], [CostoCompra], [Notas], [IdTipoActivo], [IdDepartamento], [IdStatus], [IdProveedor], [CodificacionComponentes], [TieneSoftwareOP])
VALUES
    ('ACT-004', 'HP', 'EliteDesk 800 G9', 'HP-ED-001', 'PC Contabilidad', 'Patricia Hernández Ruiz', 'Contabilidad - Puesto 15', '2023-09-10', GETDATE(), 1100.00, 'PC de escritorio para tareas contables y administrativas.', 2, 7, 1, 2, 807, 1);
GO

-- Registro 9: Tablet para Almacén
-- Componentes: Procesador(1) + Pantalla(128) + Cámara(2048) = 2177
INSERT INTO [dbo].[mActivos]
    ([Codigo], [Marca], [Modelo], [Serie], [Nombre], [PersonaAsign], [Ubicacion], [FeCompra], [FeAlta], [CostoCompra], [Notas], [IdTipoActivo], [IdDepartamento], [IdStatus], [IdProveedor], [CodificacionComponentes], [TieneSoftwareOP])
VALUES
    ('TAB-001', 'Samsung', 'Galaxy Tab S9', 'SM-GTS9-001', 'Tablet Almacén', 'Jorge Ramírez Torres', 'Almacén - Área de inventario', '2024-06-05', GETDATE(), 850.00, 'Tablet para control de inventario con escáner integrado.', 7, 9, 1, 8, 2177, 1);
GO

-- Registro 10: UPS para Servidores (En Mantenimiento)
-- Componentes: Fuente(16) solamente
INSERT INTO [dbo].[mActivos]
    ([Codigo], [Marca], [Modelo], [Serie], [Nombre], [PersonaAsign], [Ubicacion], [FeCompra], [FeAlta], [CostoCompra], [Notas], [IdTipoActivo], [IdDepartamento], [IdStatus], [IdProveedor], [CodificacionComponentes], [TieneSoftwareOP])
VALUES
    ('UPS-001', 'APC', 'Smart-UPS SRT 5000VA', 'APC-SRT-001', 'UPS Sala Servidores', 'Miguel Ángel Díaz', 'Datacenter - Rack B1', '2023-03-22', GETDATE(), 3500.00, 'UPS de respaldo para sala de servidores - En mantenimiento preventivo.', 11, 8, 2, 13, 16, 0);
GO

