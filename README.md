# IndigoAssist - Sistema Integral de Soporte Técnico y Control de Activos

## 📋 Definición del Proyecto

**IndigoAssist** es un sistema integral para la gestión de soporte técnico y control de activos que permitirá a las empresas centralizar la atención de incidencias, optimizar el tiempo de resolución y llevar un registro histórico de equipos, mantenimientos y usuarios.

El sistema será desarrollado como un producto modular que abarcará:
- **Aplicación de escritorio WinForms** para gestión interna
- **Web MVC** para administración central y acceso remoto
- **Aplicación móvil** para técnicos de campo
- **Microservicios/API** para integraciones (notificaciones)
- **Base de datos SQL Server**

## 🎯 Objetivo General

Diseñar e implementar un sistema integral de soporte técnico y activos (IndigoAssist) que permita gestionar tickets, asignar técnicos, controlar inventarios de equipos y automatizar notificaciones, siguiendo las mejores prácticas de desarrollo en .NET y alineado al plan de aprendizaje del diplomado.

## 🎯 Objetivos Específicos

- ✅ Implementar un módulo de tickets con estados, prioridades y categorías
- ✅ Integrar un control de activos por ID y bitácora de mantenimiento
- ✅ Incorporar servicios de notificación
- ✅ Desarrollar una aplicación web MVC para administración remota
- ✅ Crear una aplicación móvil para técnicos con registro de intervenciones

## 📊 Alcance del Proyecto

### Funcionalidades Principales

#### 🎫 Gestión de Tickets
- Creación, asignación, seguimiento y cierre de tickets
- Estados de tickets (Abierto, En Proceso, Resuelto, Cerrado)
- Prioridades (Baja, Media, Alta, Crítica)
- Categorías de incidencias

#### 🖥️ Gestión de Activos
- Alta y baja de equipos
- Asignación de activos a usuarios
- Bitácoras de mantenimiento
- Control de inventario por ID único

#### 👥 Usuarios y Roles
- Administración de técnicos
- Gestión de departamentos
- Sistema de permisos y roles

#### 🔔 Notificaciones
- Integración con microservicios
- Notificaciones automáticas por email/SMS
- Alertas de tickets críticos

#### 📈 Reportes
- Reportes por técnico

### Plataformas

| Plataforma | Propósito | Estado |
|------------|-----------|--------|
| **WinForms** | Gestión interna | 🚧 En desarrollo |
| **Web MVC** | Administración remota | 🚧 En desarrollo |
| **Móvil** | Técnicos de campo | 📋 Planificado |
| **API/Microservicios** | Integraciones | 📋 Planificado |

## 🗄️ Infraestructura

- **Base de datos**: SQL Server
- **Framework**: .NET 8
- **ORM**: Entity Framework Core
- **Frontend**: ASP.NET Core MVC
- **Patrón**: MVC (Model-View-Controller)

## 📅 Plan de Trabajo (Julio – Enero)

### Julio - M1. C# Básico
- ✅ Definir estructura de clases base para Tickets, Equipos, Usuarios
- ✅ Crear prototipo en WinForms con datos simulados
- ✅ Interfaz MDI, menú principal y formularios iniciales

### Agosto - M2. C# Avanzado
- ✅ Implementar lógica de negocio en capas
- ✅ Métodos para tickets y equipos (en memoria)
- ✅ Simulación de asignación de técnicos y cambio de estados
- ✅ Validaciones y manejo de excepciones

### Septiembre - M3. BD Entity Framework
- ✅ Crear base de datos SQL Server
- ✅ Reemplazar datos simulados por persistencia real
- ✅ Migraciones y pruebas de consultas
- ✅ Implementación de Entity Framework Core

### Octubre - M4. Web MVC
- 🚧 Desarrollo de aplicación web MVC
- 🚧 Implementación de controladores y vistas
- 🚧 Integración con base de datos
- 🚧 Sistema de autenticación y autorización

### Noviembre - M5. API y Microservicios
- 📋 Desarrollo de API REST
- 📋 Implementación de microservicios de notificación
- 📋 Documentación con Swagger
- 📋 Pruebas de integración

### Diciembre - M6. Aplicación Móvil
- 📋 Desarrollo de aplicación móvil
- 📋 Sincronización con API
- 📋 Funcionalidades offline
- 📋 Pruebas en dispositivos

### Enero - M7. Despliegue y Producción
- 📋 Configuración de servidor
- 📋 Despliegue en producción
- 📋 Pruebas de carga
- 📋 Documentación final

## 🏗️ Estructura del Proyecto

```
IndigoAssistMVC/
├── Controllers/          # Controladores MVC
├── Models/              # Modelos de datos
├── ViewModels/          # ViewModels para vistas
├── Views/               # Vistas Razor
├── Data/                # Contexto de base de datos
├── wwwroot/             # Archivos estáticos
└── ScriptBD/            # Scripts de base de datos
```

## 🚀 Tecnologías Utilizadas

- **.NET 8**
- **ASP.NET Core MVC**
- **Entity Framework Core**
- **SQL Server**
- **Bootstrap 5**
- **jQuery**
- **C#**

## 📝 Estado Actual

El proyecto se encuentra en la fase de desarrollo de la aplicación web MVC, con funcionalidades básicas implementadas. Se ha completado:

- ✅ Estructura base del proyecto MVC
- ✅ Modelo de datos para Activos
- ✅ Controlador y vistas para gestión de activos
- ✅ Integración con Entity Framework Core
- ✅ Base de datos SQL Server configurada
- ✅ **NUEVO:** Sistema de gestión de usuarios (mockup)
- ✅ **NUEVO:** Interfaz de login con autenticación
- ✅ **NUEVO:** Dashboard de usuarios con estadísticas
- ✅ **NUEVO:** Sistema de autenticación con ASP.NET Core Identity

## 🆕 Nuevas Funcionalidades Implementadas

### 🔐 Sistema de Autenticación
- **Login seguro** con validación de credenciales
- **Autenticación con ASP.NET Core Identity** (moderno y seguro)
- **Integración con sistema legacy** (simulado)
- **Gestión de sesiones** con opción "Recordarme"
- **Logout seguro** con limpieza de sesión
- **Configuración de contraseñas** con políticas de seguridad
- **Bloqueo de cuentas** por intentos fallidos

### 👥 Gestión de Usuarios (Mockup)
- **Lista de usuarios** con información completa
- **Dashboard personalizado** por usuario
- **Estadísticas de tickets** (solucionados, en proceso, pendientes)
- **Filtros dinámicos** por estado y rol
- **Vista de detalles** con información del sistema legacy
- **Timeline de actividad** del usuario

### 📊 Dashboard de Usuarios
- **Estadísticas en tiempo real** de tickets
- **Tickets en proceso** con información detallada
- **Tickets solucionados** con tiempo de resolución
- **Gráficos visuales** con colores por estado
- **Auto-refresh** cada 5 minutos

### 🎨 Interfaz de Usuario
- **Diseño moderno** con Bootstrap 5
- **Iconos FontAwesome** para mejor UX
- **Responsive design** para móviles
- **Animaciones suaves** en hover y transiciones
- **Colores por estado** para fácil identificación

## 🔧 Instalación y Configuración

### Prerrequisitos
- .NET 8 SDK
- SQL Server (LocalDB o Express)
- Visual Studio 2022 o VS Code

### Pasos de instalación
1. Clonar el repositorio
2. Restaurar paquetes NuGet
3. Configurar la cadena de conexión en `appsettings.json`
4. Ejecutar migraciones de Entity Framework
5. Ejecutar el proyecto

### 👤 Usuarios de Prueba
Para probar el sistema de autenticación, puedes usar estos usuarios:

| Usuario | Contraseña | Rol | Departamento |
|---------|------------|-----|--------------|
| `admin` | `admin123` | Administrador | Sistemas |
| `jperez` | `password123` | Administrador | Sistemas |
| `mgonzalez` | `password123` | Técnico | Recursos Humanos |
| `crodriguez` | `password123` | Técnico | Sistemas |
| `test` | `test123` | Técnico | Sistemas |

## 📞 Contacto

Para más información sobre el proyecto, contactar al equipo de desarrollo.

---

**Desarrollado como parte del Diplomado en Desarrollo de Software con .NET**
