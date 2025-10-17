# 🚀 IndigoAssist - Sistema Integral de Gestión de Tickets y Activos

<div align="center">

![IndigoAssist Logo](https://img.shields.io/badge/IndigoAssist-v1.0-blue?style=for-the-badge&logo=dotnet)
![.NET](https://img.shields.io/badge/.NET-8.0-purple?style=flat-square&logo=dotnet)
![ASP.NET Core](https://img.shields.io/badge/ASP.NET%20Core-MVC-green?style=flat-square&logo=aspnet)
![SQL Server](https://img.shields.io/badge/SQL%20Server-2022-red?style=flat-square&logo=microsoftsqlserver)

**Plataforma moderna para gestión de tickets y activos empresariales**

*Desarrollado como proyecto del Diplomado en Desarrollo de Software con .NET*

</div>

---

## 📋 Definición del Proyecto

**IndigoAssist** es un sistema integral para la gestión de soporte técnico y control de activos que permitirá a las empresas centralizar la atención de incidencias, optimizar el tiempo de resolución y llevar un registro histórico de equipos, mantenimientos y usuarios.

### 🏗️ Arquitectura Modular

El sistema será desarrollado como un producto modular que abarcará:

| Componente | Tecnología | Propósito | Estado |
|------------|------------|-----------|--------|
| **🖥️ Aplicación Web MVC** | ASP.NET Core MVC | Administración central y acceso remoto | 🚧 En desarrollo |
| **🔌 API/Microservicios** | ASP.NET Core Web API | Integraciones y notificaciones | 📋 Planificado |
| **📱 Aplicación Móvil** | .NET MAUI | Gestión de tickets para técnicos de campo | 📋 Planificado |
| **🗄️ Base de Datos** | SQL Server | Persistencia de datos | ✅ Implementado |

## 🎯 Objetivos del Proyecto

### 🎯 Objetivo General
Diseñar e implementar un sistema integral de soporte técnico y activos (IndigoAssist) que permita gestionar tickets, 
asignar técnicos, controlar inventarios de equipos y automatizar notificaciones, 
siguiendo las mejores prácticas de desarrollo en .NET y alineado al plan de aprendizaje del diplomado.

### 🎯 Objetivos Específicos

- ✅ **Gestión de Tickets**: Implementar módulo con estados, prioridades y categorías
- ✅ **Control de Activos**: Integrar control por ID y bitácora de mantenimiento  
- 🔄 **Notificaciones**: Incorporar servicios de notificación automática
- ✅ **Plataforma Web**: Desarrollar aplicación MVC para administración remota
- 📋 **App Móvil**: Crear aplicación para técnicos con registro de intervenciones

## 📊 Alcance del Proyecto

### 🎫 Gestión de Tickets
- **Creación y asignación** de tickets de soporte técnico
- **Estados de tickets**: Abierto, En Proceso, Resuelto, Cerrado
- **Prioridades**: Baja, Media, Alta, Crítica
- **Categorías** de incidencias y tipos de soporte
- **Seguimiento en tiempo real** del progreso
- **Dashboard por usuario** con tickets asignados

### 🖥️ Gestión de Activos
- **Alta y baja** de equipos y dispositivos
- **Asignación de activos** a usuarios y departamentos
- **Bitácoras de mantenimiento** con historial completo
- **Control de inventario** por ID único y códigos de barras

### 👥 Control de Usuarios
- **Administración de técnicos** y personal de soporte
- **Gestión de departamentos** y áreas organizacionales
- **Sistema de permisos** y roles de acceso
- **Autenticación segura** con ASP.NET Core Identity
- **Dashboard personalizado** por usuario

### 🔔 Sistema de Notificaciones
- **Integración con microservicios** para notificaciones
- **Notificaciones automáticas** por email 
- **Alertas de tickets críticos** en tiempo real
- **Notificaciones push** para aplicación móvil
- **Configuración personalizable** de alertas

### 📈 Reportes y Analytics
- **Reportes por técnico** con métricas de rendimiento
- **Reportes por estado** de tickets
- **Reportes por equipo** y activos
- **Dashboard ejecutivo** con KPIs
- **Exportación** a PDF y Excel

## 🗄️ Infraestructura

- **Base de datos**: SQL Server
- **Framework**: .NET 8
- **ORM**: Entity Framework Core
- **Frontend**: ASP.NET Core MVC
- **Patrón**: MVC (Model-View-Controller)

### ⚙️ Variables del Sistema

Los scripts incluyen configuración automática:

```sql
-- Variables configuradas automáticamente
TicketNoEncuestas = '2'        -- Máximo encuestas por día
TicketTiempoMaximo = '480'      -- Tiempo máximo en minutos
TicketNotificacionEmail = '1'   -- Notificaciones habilitadas
TicketAutoAsignacion = '0'      -- Auto-asignación deshabilitada
```

### 🔄 Secuencia de Ejecución Recomendada

#### Opción 1: Instalación Completa (Recomendada)
```sql
-- 1. Crear base de datos
CREATE DATABASE [IndigoBasic];
GO

-- 2. Ejecutar script completo
-- Archivo: ScriptBD/IndigoBasic_Nueva.sql
-- ⚠️ IMPORTANTE: Este script incluye TODO el sistema
```

#### Opción 2: Instalación Modular
```sql
-- 1. Crear base de datos
CREATE DATABASE [IndigoBasic];
GO

-- 2. Sistema de Tickets (Base)
-- Archivo: ScriptBD/Tickets_Isolated_Script.sql
-- Incluye: Usuarios, departamentos, tickets, catálogos

-- 3. Sistema de Activos (Adicional)
-- Archivo: ScriptBD/IndigoBasic.sql  
-- Incluye: Activos, componentes, proveedores
```

#### ⚠️ Notas Importantes

1. **No ejecutar `CreateIdentityTables.sql`** - Es redundante con `IndigoBasic_Nueva.sql`
2. **Los scripts son autocontenidos** - No requieren dependencias externas
3. **Los seeders están incluidos** - La BD queda lista para usar inmediatamente
4. **Orden de ejecución** - Los scripts están ordenados correctamente internamente
5. **Base de datos** - Debe llamarse exactamente `IndigoBasic`

#### 🚀 Verificación Post-Instalación

Después de ejecutar los scripts, verificar que existan estas tablas principales:

```sql
-- Verificar tablas principales
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME IN (
    'mTickets', 'mActivos', 'AspNetUsers', 
    'mPersonas', 'mEmpleados', 'mDepartamentos'
);

-- Verificar datos de prueba
SELECT COUNT(*) FROM mTickets;        -- Debe ser > 0
SELECT COUNT(*) FROM mActivos;        -- Debe ser > 0  
SELECT COUNT(*) FROM AspNetUsers;     -- Debe ser > 0
```

## 📊 Base de Datos y Scripts

### 🗂️ Scripts Disponibles

El proyecto incluye scripts completos de base de datos en la carpeta `ScriptBD/`:

| Archivo | Descripción | Tamaño | Incluye Seeders |
|---------|-------------|--------|-----------------|
| `IndigoBasic_Nueva.sql` | **Script completo recomendado** - Sistema completo con tickets, activos e Identity | 40KB | ✅ Sí |
| `Tickets_Isolated_Script.sql` | Sistema completo de tickets con datos de prueba | 38KB | ✅ Sí |
| `IndigoBasic.sql` | Sistema básico de activos con datos iniciales | 14KB | ✅ Sí |
| `CreateIdentityTables.sql` | Solo tablas de Identity (redundante) | 6KB | ❌ No |

### 🎯 Recomendación de Uso

**Para instalación completa (Recomendado):**
```sql
-- Usar solo este archivo
ScriptBD/IndigoBasic_Nueva.sql
```

**Para desarrollo modular:**
```sql
-- 1. Sistema de tickets completo
ScriptBD/Tickets_Isolated_Script.sql

-- 2. Sistema de activos
ScriptBD/IndigoBasic.sql
```

### 📋 Contenido de los Scripts

#### `IndigoBasic_Nueva.sql` (Completo)
- ✅ **Sistema de Tickets**: Tablas completas con relaciones
- ✅ **Sistema de Activos**: Gestión de equipos y dispositivos  
- ✅ **ASP.NET Identity**: Tablas de autenticación
- ✅ **Datos de Prueba**: Usuarios, departamentos, tickets, activos
- ✅ **Funciones y Procedimientos**: Lógica de negocio
- ✅ **Vistas**: Consultas optimizadas

#### `Tickets_Isolated_Script.sql` (Solo Tickets)
- ✅ **Sistema de Tickets Completo**: 20+ tablas relacionadas
- ✅ **Datos de Prueba**: 5 usuarios, 5 tickets activos, 2 históricos
- ✅ **Catálogos**: Estados, prioridades, categorías, subcategorías
- ✅ **Funciones**: GetSysVar, GetAnotacionesTecnicosTicket
- ✅ **Procedimientos**: TicketValoracionEnviar
- ✅ **Vistas**: vTickets, vhTickets, vEmpleados

#### `IndigoBasic.sql` (Solo Activos)
- ✅ **Gestión de Activos**: Equipos, componentes, proveedores
- ✅ **Datos de Prueba**: 10 activos de ejemplo
- ✅ **Catálogos**: Tipos, estados, departamentos, software
- ✅ **Codificación de Componentes**: Sistema de bits para componentes

### 🔧 Estructura de la Base de Datos

#### Sistema de Tickets
- **Tablas Principales**: mTickets, mPersonas, mEmpleados
- **Catálogos**: Estados, prioridades, tipos, categorías
- **Histórico**: hTickets, hdTickets (tickets cerrados)
- **Log**: dTickets (eventos y actividades)
- **Asignaciones**: dTicketsTecnicos (técnicos por ticket)

#### Sistema de Activos  
- **Tablas Principales**: mActivos, mTiposActivo, mStatus
- **Catálogos**: Departamentos, proveedores, software, componentes
- **Codificación**: Sistema de bits para componentes de hardware

#### Sistema de Autenticación
- **ASP.NET Identity**: AspNetUsers, AspNetRoles, AspNetUserRoles
- **Campos Personalizados**: NombreCompleto, IdDepartamento, Activo

### 👥 Usuarios de Prueba Incluidos

| Usuario | Contraseña | Rol | Departamento | Descripción |
|---------|------------|-----|--------------|-------------|
| `admin` | `admin123` | Administrador | Sistemas | Usuario principal |
| `jperez` | `password123` | Administrador | Sistemas | Administrador |
| `mgonzalez` | `password123` | Técnico | Recursos Humanos | Técnico RH |
| `crodriguez` | `password123` | Técnico | Sistemas | Técnico IT |
| `test` | `test123` | Técnico | Sistemas | Usuario de prueba |

### 📊 Datos de Prueba Incluidos

#### Sistema de Tickets
- **5 Departamentos**: Sistemas, RH, Contabilidad, Ventas, Almacén
- **11 Puestos**: Desde Gerentes hasta Operadores
- **10 Categorías**: Hardware, Software, Redes, Usuarios, etc.
- **30 Subcategorías**: Equipos, Impresoras, Servidores, etc.
- **5 Tickets Activos**: Con diferentes estados y prioridades
- **2 Tickets Históricos**: Cerrados con valoraciones

#### Sistema de Activos
- **12 Tipos de Activos**: Laptop, PC, Servidor, Impresora, etc.
- **12 Departamentos**: Ventas, Soporte, RH, Finanzas, etc.
- **15 Proveedores**: Dell, HP, Lenovo, Apple, Microsoft, etc.
- **14 Componentes**: Procesador, RAM, SSD, Tarjeta Gráfica, etc.
- **21 Software**: Windows, Office, Adobe, etc.
- **10 Activos de Ejemplo**: Con asignaciones y ubicaciones

## 📅 Plan de Trabajo - Cronograma del Diplomado

### 📅 Julio - M1. C# Básico
- ✅ **Definir estructura de clases base** para Tickets, Equipos, Usuarios
- ✅ **Crear prototipo en WinForms** con datos simulados
- ✅ **Interfaz MDI**, menú principal y formularios iniciales

### 📅 Agosto - M2. C# Avanzado  
- ✅ **Implementar lógica de negocio** en capas
- ✅ **Métodos para tickets y equipos** (en memoria)
- ✅ **Simulación de asignación** de técnicos y cambio de estados
- ✅ **Validaciones y manejo** de excepciones

### 📅 Septiembre - M3. BD Entity Framework
- ✅ **Crear base de datos** SQL Server
- ✅ **Reemplazar datos simulados** por persistencia real
- ✅ **Migraciones y pruebas** de consultas
- ✅ **Implementación de Entity Framework Core**

### 📅 Octubre - M4. ASP.NET Core MVC
- 🚧 **Desarrollar módulo web administrativo**
- 🚧 **Autenticación y roles** básicos
- 🚧 **Listado y búsqueda** de tickets y activos
- 🚧 **Filtros y reportes** simples en web

### 📅 Noviembre - M5. Servicios
- 📋 **Implementar API REST** para Tickets y Activos
- 📋 **Conexión entre Web, WinForms y Móvil** a través de API
- 📋 **Microservicios de notificación**
- 📋 **Documentación con Swagger**

### 📅 Diciembre - M6. Implementación Azure
- 📋 **Configurar hosting** de API y Web
- 📋 **Base de datos en Azure SQL**
- 📋 **Ajustar seguridad** y accesos
- 📋 **Despliegue en producción**

### 📅 Enero - M7. Móviles
- 📋 **Desarrollar app móvil** para técnicos (MAUI o Xamarin)
- 📋 **Conexión a API**
- 📋 **Funciones de ver tickets**, actualizar estados y registrar mantenimiento
- 📋 **Presentación final** y entrega del proyecto

## 🏗️ Estructura del Proyecto

```
IndigoAssistMVC/
├── 📁 Controllers/          # Controladores MVC
│   ├── ActivoController.cs  # Gestión de activos
│   ├── TicketController.cs  # Gestión de tickets
│   └── UsuarioController.cs # Gestión de usuarios
├── 📁 Models/               # Modelos de datos
│   ├── Activo.cs           # Modelo de activos
│   ├── TicketModels.cs     # Modelos de tickets
│   └── UsuarioModels.cs    # Modelos de usuarios
├── 📁 ViewModels/           # ViewModels para vistas
│   ├── ActivoViewModel.cs  # Vista de activos
│   └── UsuarioGestionViewModel.cs # Gestión de usuarios
├── 📁 Views/                # Vistas Razor
│   ├── Activo/             # Vistas de activos
│   ├── Ticket/             # Vistas de tickets
│   └── Usuario/            # Vistas de usuarios
├── 📁 Data/                 # Contexto de base de datos
│   ├── IndigoDBContext.cs  # Contexto principal
│   └── Seeders/            # Datos iniciales
├── 📁 wwwroot/              # Archivos estáticos
└── 📁 ScriptBD/             # Scripts de base de datos
```

## 🚀 Stack Tecnológico

### 🎯 Backend
- **.NET 8** - Framework principal
- **ASP.NET Core MVC** - Framework web
- **Entity Framework Core** - ORM para base de datos
- **ASP.NET Core Identity** - Sistema de autenticación
- **C#** - Lenguaje de programación

### 🗄️ Base de Datos
- **SQL Server** - Base de datos principal
- **Entity Framework Migrations** - Control de versiones de BD

### 🎨 Frontend
- **Bootstrap 5** - Framework CSS
- **jQuery** - Biblioteca JavaScript
- **FontAwesome** - Iconos
- **Razor Pages** - Motor de vistas

### 🔧 Herramientas de Desarrollo
- **Visual Studio 2022** - IDE principal
- **SQL Server Management Studio** - Gestión de BD
- **Git** - Control de versiones

## 📝 Estado Actual del Proyecto

### 🎯 Fase Actual: **M4. ASP.NET Core MVC** (Octubre)

El proyecto se encuentra en la fase de desarrollo de la aplicación web MVC, con funcionalidades básicas implementadas y en continuo crecimiento.

### ✅ Completado

#### 🏗️ Infraestructura Base
- ✅ **Estructura base** del proyecto MVC
- ✅ **Base de datos SQL Server** configurada
- ✅ **Entity Framework Core** implementado
- ✅ **Migraciones** y control de versiones de BD

#### 🖥️ Gestión de Activos
- ✅ **Modelo de datos** para Activos
- ✅ **Controlador y vistas** para gestión de activos
- ✅ **CRUD completo** (Create, Read, Update, Delete)
- ✅ **Filtros y búsqueda** de activos

#### 👥 Sistema de Usuarios
- ✅ **Sistema de autenticación** con ASP.NET Core Identity
- ✅ **Gestión de usuarios** (mockup funcional)
- ✅ **Interfaz de login** con autenticación segura
- ✅ **Dashboard de usuarios** con estadísticas
- ✅ **Control de roles** y permisos

#### 🎫 Gestión de Tickets (Parcial)
- ✅ **Estructura base** para tickets
- ✅ **Vistas iniciales** de tickets
- 🔄 **En desarrollo**: Lógica de negocio completa

## 🚀 Funcionalidades Implementadas

### 🔐 Sistema de Autenticación Avanzado
- **Login seguro** con validación de credenciales
- **ASP.NET Core Identity** (moderno y seguro)
- **Integración con sistema legacy** (simulado)
- **Gestión de sesiones** con opción "Recordarme"
- **Logout seguro** con limpieza de sesión
- **Políticas de contraseñas** con seguridad robusta
- **Bloqueo de cuentas** por intentos fallidos

### 👥 Gestión Integral de Usuarios
- **Lista completa de usuarios** con información detallada
- **Dashboard personalizado** por usuario
- **Estadísticas de tickets** (solucionados, en proceso, pendientes)
- **Filtros dinámicos** por estado y rol
- **Vista de detalles** con información del sistema legacy
- **Timeline de actividad** del usuario

### 📊 Dashboard Interactivo
- **Estadísticas en tiempo real** de tickets
- **Tickets en proceso** con información detallada
- **Tickets solucionados** con tiempo de resolución
- **Gráficos visuales** con colores por estado
- **Auto-refresh** cada 5 minutos
- **Métricas de rendimiento** por técnico

### 🎨 Interfaz de Usuario Moderna
- **Diseño moderno** con Bootstrap 5
- **Iconos FontAwesome** para mejor UX
- **Responsive design** para móviles y tablets
- **Animaciones suaves** en hover y transiciones
- **Colores por estado** para fácil identificación
- **Navegación intuitiva** con breadcrumbs

### 🖥️ Gestión de Activos
- **CRUD completo** de activos y equipos
- **Búsqueda y filtros** avanzados
- **Asignación de activos** a usuarios
- **Historial de movimientos** y cambios
- **Códigos de barras** para identificación

## 🔧 Instalación y Configuración

### 📋 Prerrequisitos
- **.NET 8 SDK** (última versión)
- **SQL Server** (LocalDB, Express o Developer)
- **Visual Studio 2022** o **VS Code**
- **Git** (para clonar el repositorio)

### 🚀 Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/Jcarrazco/IndigoAssistsMVC
   cd IndigoAssistMVC
   ```

2. **Restaurar paquetes NuGet**
   ```bash
   dotnet restore
   ```

3. **Configurar la base de datos**
   - Crear la base de datos `IndigoBasic` en SQL Server
   - Elige UNA de las siguientes rutas:

   **Ruta A (Recomendada) - Migraciones EF (Identity por migración) + Seeders:**
   1) Ejecuta migraciones para crear el esquema completo (incluye Identity):
   ```bash
   dotnet ef database update
   ```
   2) Abre `ScriptBD/IndigoBasic_Nueva.sql` y ejecuta SOLO la sección "SEEDERS" (desde el encabezado `SEEDERS` hasta el final) para poblar catálogos, personas, activos y datos de prueba.

   **Ruta B - Script completo (sin migraciones):**
   ```sql
   -- Ejecutar en SQL Server Management Studio o Azure Data Studio
   -- 1) Crear base de datos
   CREATE DATABASE [IndigoBasic];
   GO

   -- 2) Ejecutar script completo
   -- Archivo: ScriptBD/IndigoBasic_Nueva.sql
   ```
   (En esta ruta no es necesario ejecutar migraciones EF.)

4. **Configurar la cadena de conexión**
   - Editar `appsettings.json`
   - Configurar la cadena de conexión a SQL Server:
   ```json
   {
     "ConnectionStrings": {
       "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=IndigoBasic;Trusted_Connection=true;MultipleActiveResultSets=true"
     }
   }
   ```

5. **Ejecutar el proyecto**
   ```bash
   dotnet run
   ```

### 👤 Usuarios de Prueba

Para probar el sistema de autenticación, puedes usar estos usuarios:

| Usuario | Contraseña | Rol | Departamento |
|---------|------------|-----|--------------|
| `admin` | `admin123` | Administrador | Sistemas |
| `jperez` | `password123` | Administrador | Sistemas |
| `mgonzalez` | `password123` | Técnico | Recursos Humanos |
| `crodriguez` | `password123` | Técnico | Sistemas |
| `test` | `test123` | Técnico | Sistemas |

## 📈 Próximos Pasos

### 🔄 En Desarrollo (Octubre)
- **Completar módulo de tickets** con lógica de negocio
- **Implementar notificaciones** básicas
- **Mejorar dashboard** con más métricas
- **Optimizar rendimiento** de consultas

### 📋 Planificado (Noviembre - Enero)
- **API REST** para integraciones
- **Aplicación móvil** para técnicos
- **Microservicios** de notificación
- **Despliegue en Azure**

## 🤝 Contribución

Este proyecto es parte del **Diplomado en Desarrollo de Software con .NET** y está diseñado para demostrar las mejores prácticas en desarrollo de software empresarial.

## 📞 Contacto

Para más información sobre el proyecto, contactar al equipo de desarrollo.

---

<div align="center">

**🚀 Desarrollado como parte del Diplomado en Desarrollo de Software con .NET**

*IndigoAssist - Sistema Integral de Gestión de Tickets y Activos*

</div>
