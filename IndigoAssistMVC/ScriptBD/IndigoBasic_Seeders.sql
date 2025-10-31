USE IndigoBasic
--Scripts de la BD Legacy
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

-- Departamentos (requerido antes de otros catálogos)
IF NOT EXISTS (SELECT 1 FROM [dbo].[mDepartamentos])
BEGIN
    INSERT INTO [dbo].[mDepartamentos] (Departamento, Tickets)
    VALUES ('Ventas', 1),('Soporte Técnico', 1),('Recursos Humanos', 1),('Facturación', 1),('Marketing', 1),('Dirección General', 1),('Contabilidad', 1),('Sistemas', 1),('Almacén', 1);
END
GO

-- Puestos (requerido antes de mEmpleados)
IF NOT EXISTS (SELECT 1 FROM [dbo].[mPuestos])
BEGIN
    INSERT INTO [dbo].[mPuestos] (Puesto, IdDepto)
    VALUES ('Director General', 6),('Gerente de TI', 8),('Técnico Senior', 2),('Técnico Junior', 2),('Analista de Sistemas', 8),('Desarrollador', 8),('Administrador de BD', 8),('Ejecutivo de Ventas', 1),('Supervisor de Almacén', 9);
END
GO

-- Cat�logos de Activos
IF NOT EXISTS (SELECT 1 FROM [dbo].[mTiposActivo])
BEGIN
    INSERT INTO [dbo].[mTiposActivo] (TipoActivo)
    VALUES ('Laptop'), ('PC de Escritorio'), ('Servidor'), ('Impresora'), ('Router'), ('Monitor'), ('Tablet'), ('Smartphone'), ('Switch de Red'), ('Firewall'), ('UPS'), ('Esc�ner');
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
    VALUES ('Procesador',1),('Memoria RAM',2),('Disco Duro SSD',4),('Tarjeta Gr�fica',8),('Fuente de Poder',16),('Tarjeta de Red',32),('Ventiladores',64),('Pantalla',128),('Teclado',256),('Mouse',512),('Bocinas',1024),('C�mara Web',2048),('Micr�fono',4096),('Disco Duro HDD',8192);
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[mSoftware])
BEGIN
    INSERT INTO [dbo].[mSoftware] (Nombre)
    VALUES ('Windows 11 Pro'),('Windows 10 Pro'),('Windows Server 2022'),('macOS Sonoma'),('macOS Ventura'),('Ubuntu 22.04 LTS'),('Ubuntu 20.04 LTS'),('Red Hat Enterprise Linux'),('CentOS Stream'),('Microsoft Office 365'),('Microsoft Office 2021'),('Adobe Creative Cloud'),('Adobe Acrobat Pro'),('Google Workspace'),('Zoom Professional'),('Microsoft Teams'),('Slack'),('Visual Studio Professional'),('IntelliJ IDEA'),('Photoshop CC');
END
GO

-- Activos de ejemplo (requiere cat�logos previos)
IF NOT EXISTS (SELECT 1 FROM [dbo].[mActivos])
BEGIN
    INSERT INTO [dbo].[mActivos] (Codigo, Marca, Modelo, Serie, Nombre, PersonaAsign, Ubicacion, FeCompra, FeAlta, CostoCompra, Notas, IdTipoActivo, IdDepartamento, IdStatus, IdProveedor, CodificacionComponentes, TieneSoftwareOP)
    VALUES
    ('ACT-001','Dell','XPS 15','DL-XPS-001','Laptop Ejecutiva','Ana P�rez Garc�a','Direcci�n General - Oficina 101','2024-03-15',GETDATE(),2850.50,'Laptop de alto rendimiento para direcci�n general con pantalla 4K.',1,6,1,1,903,1),
    ('ACT-002','HP','ProDesk 400 G9','HP-PD-002','PC Soporte T�cnico','Carlos G�mez L�pez','Soporte T�cnico - Puesto 23','2023-11-20',GETDATE(),1200.00,'Equipo est�ndar para el �rea de soporte t�cnico.',2,2,1,2,63,1),
    ('SRV-001','Dell','PowerEdge R740','DL-PE-001','Servidor BD Principal','Mar�a Gonz�lez Ruiz','Datacenter - Rack A1','2024-01-10',GETDATE(),8500.00,'Servidor principal de base de datos con alta disponibilidad.',3,8,1,1,8311,1),
    ('IMP-001','Canon','imageRUNNER ADVANCE C3330i','CN-IR-001','Impresora Multifuncional Color',NULL,'Recursos Humanos - �rea com�n','2023-08-15',GETDATE(),3200.00,'Impresora multifuncional a color para el departamento de RRHH.',4,3,1,9,0,0),
    ('NET-001','Cisco','ISR 4331','CS-ISR-001','Router Principal','Luis Mart�nez Vega','Sistemas - Cuarto de comunicaciones','2023-05-20',GETDATE(),2800.00,'Router principal para conectividad de la empresa.',5,8,1,11,49,1),
    ('MON-001','ASUS','ProArt PA348CGV','AS-PA-001','Monitor Ultrawide 34"','Sandra L�pez Morales','Marketing - Estaci�n de dise�o','2024-02-28',GETDATE(),1850.00,'Monitor ultrawide para dise�o gr�fico y marketing.',6,5,1,6,128,0),
    ('ACT-003','Lenovo','ThinkPad X1 Carbon','LN-X1-001','Laptop Ventas','Roberto Silva Castro','Ventas - Oficina m�vil','2024-04-12',GETDATE(),2200.00,'Laptop ligera para el equipo de ventas con c�mara HD.',1,1,1,3,2951,1),
    ('ACT-004','HP','EliteDesk 800 G9','HP-ED-001','PC Contabilidad','Patricia Hern�ndez Ruiz','Contabilidad - Puesto 15','2023-09-10',GETDATE(),1100.00,'PC de escritorio para tareas contables y administrativas.',2,7,1,2,807,1),
    ('TAB-001','Samsung','Galaxy Tab S9','SM-GTS9-001','Tablet Almac�n','Jorge Ram�rez Torres','Almac�n - �rea de inventario','2024-06-05',GETDATE(),850.00,'Tablet para control de inventario con esc�ner integrado.',7,9,1,8,2177,1),
    ('UPS-001','APC','Smart-UPS SRT 5000VA','APC-SRT-001','UPS Sala Servidores','Miguel �ngel D�az','Datacenter - Rack B1','2023-03-22',GETDATE(),3500.00,'UPS de respaldo para sala de servidores - En mantenimiento preventivo.',11,8,2,13,16,0);
END
GO

-- Personas / Empresa / PerEmp
IF NOT EXISTS (SELECT 1 FROM [dbo].[mPersonas])
BEGIN
    INSERT INTO [dbo].[mPersonas] (Nombre, Paterno, Materno, Descripcion, RFC, Email, TipoPersona, Usuario, FeModifica)
    VALUES ('Juan Carlos','Garc�a','L�pez','Administrador del Sistema','GALJ800101ABC','juan.garcia@empresa.com','F','ADMIN',GETDATE()),
           ('Mar�a Elena','Rodr�guez','Mart�nez','Gerente de TI','ROMM850215DEF','maria.rodriguez@empresa.com','F','ADMIN',GETDATE()),
           ('Carlos Alberto','Hern�ndez','Gonz�lez','T�cnico Senior','HEGC900310GHI','carlos.hernandez@empresa.com','F','ADMIN',GETDATE()),
           ('Ana Patricia','S�nchez','Flores','T�cnico Junior','SAFA920425JKL','ana.sanchez@empresa.com','F','ADMIN',GETDATE()),
           ('Roberto','Jim�nez','Vega','Usuario Final','JIVR880720MNO','roberto.jimenez@empresa.com','F','ADMIN',GETDATE()),
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

-- Cat�logos de Tickets (mDepartamentos/mPuestos ya definidos arriba)
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
    VALUES ('Hardware',1),('Software',1),('Redes',1),('Usuarios',1),('Solicitudes RH',2),('N�mina',2),('Contabilidad',3),('Facturaci�n',3),('Ventas',4),('CRM',4);
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[mSubCategoriasTicket])
BEGIN
    INSERT INTO [dbo].[mSubCategoriasTicket] (SubCategoria, IdCategoria)
    VALUES ('Equipos de C�mputo',1),('Impresoras',1),('Servidores',1),('Dispositivos M�viles',1),
           ('Sistema Operativo',2),('Aplicaciones',2),('Antivirus',2),('Licencias',2),
           ('Conectividad',3),('Internet',3),('Correo Electr�nico',3),('Acceso Remoto',3),
           ('Accesos',4),('Contrase�as',4),('Permisos',4),('Capacitaci�n',4),
           ('Altas',5),('Bajas',5),('Cambios',5),('Consultas',5),
           ('C�lculos',6),('Reportes',6),('Errores',6),
           ('Asientos',7),('Reportes',7),('Conciliaciones',7),
           ('Facturas',8),('Notas de Cr�dito',8),('Cancelaciones',8),
           ('Cotizaciones',9),('Pedidos',9),('Clientes',9),
           ('Configuraci�n',10),('Reportes',10),('Integraci�n',10);
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
    VALUES (5,1,'Laptop no enciende','La laptop del usuario no enciende despu�s de actualizaci�n del sistema',1,1,2,GETDATE(),NULL,DATEADD(day,2,GETDATE())),
           (5,5,'Problema con Outlook','No puede enviar correos electr�nicos desde Outlook',2,1,1,DATEADD(day,-1,GETDATE()),DATEADD(day,-1,GETDATE()),DATEADD(day,1,GETDATE())),
           (5,9,'Sin acceso a Internet','No tiene conexi�n a Internet en su estaci�n de trabajo',1,1,3,GETDATE(),NULL,DATEADD(day,1,GETDATE())),
           (5,13,'Solicitud de acceso','Necesita acceso al sistema de facturaci�n',2,2,2,DATEADD(day,-2,GETDATE()),DATEADD(day,-2,GETDATE()),GETDATE()),
           (5,17,'Cambio de contrase�a','Solicita cambio de contrase�a de dominio',1,2,1,GETDATE(),NULL,DATEADD(day,1,GETDATE()));
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
    VALUES (2,'Ticket asignado al t�cnico Carlos Hern�ndez',0,DATEADD(day,-1,GETDATE()),'ADMIN'),
           (2,'Se realiz� diagn�stico inicial del problema',30,DATEADD(day,-1,GETDATE()),'CARLOS.H'),
           (2,'Se identific� problema con configuraci�n SMTP',45,DATEADD(day,-1,GETDATE()),'CARLOS.H'),
           (4,'Ticket asignado al t�cnico Carlos Hern�ndez',0,DATEADD(day,-2,GETDATE()),'ADMIN'),
           (4,'Se verificaron permisos del usuario',20,DATEADD(day,-2,GETDATE()),'CARLOS.H'),
           (4,'Se otorg� acceso al sistema de facturaci�n',15,DATEADD(day,-1,GETDATE()),'CARLOS.H');
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
           (2002,1001,'Se realiz� diagn�stico',30,DATEADD(day,-10,GETDATE()),'CARLOS.H'),
           (2003,1001,'Se reinstal� Excel',60,DATEADD(day,-9,GETDATE()),'CARLOS.H'),
           (2004,1001,'Ticket cerrado - Problema resuelto',0,DATEADD(day,-8,GETDATE()),'CARLOS.H'),
           (2005,1002,'Ticket asignado',0,DATEADD(day,-15,GETDATE()),'ADMIN'),
           (2006,1002,'Se verific� licencia',15,DATEADD(day,-15,GETDATE()),'ANA.S'),
           (2007,1002,'Se instal� Adobe Acrobat',45,DATEADD(day,-14,GETDATE()),'ANA.S'),
           (2008,1002,'Ticket cerrado - Software instalado',0,DATEADD(day,-13,GETDATE()),'ANA.S');
END
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[mValoracionTicket])
BEGIN
    INSERT INTO [dbo].[mValoracionTicket] (IdTicket, Fecha, Valoracion, Comentario)
    VALUES (1001,DATEADD(day,-7,GETDATE()),5,'Excelente atenci�n, problema resuelto r�pidamente'),
           (1002,DATEADD(day,-12,GETDATE()),4,'Buen servicio, instalaci�n exitosa');
END
GO

-- Identity Roles (solo roles, usuarios se crean v�a app si se requiere)
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
