# 📋 Lista de Requisitos — Proyecto IndigoAssist

## 1. App Web (ASP.NET Core MVC)

### 1.1 Requerimientos Funcionales

- **WEB-RF1. Autenticación y Roles.**  
  Inicio de sesión, cierre, recuperación; autorización por rol (Administrador, Mesa de Ayuda, Técnico, Auditor).

- **WEB-RF2. Gestión de Tickets.**  
  - CRUD: solicitante, categoría, prioridad, estado, técnico, SLA, adjuntos.  
  - Filtros combinables: estado, prioridad, técnico, fecha, sucursal.  
  - Acciones masivas: reasignar, cambiar estado, cerrar.

- **WEB-RF3. Dashboard Accionable.**  
  - Vistas: vencidos, próximos a vencer, en espera del usuario.  
  - Acciones rápidas en tarjeta: reasignar, comentar, cerrar.

- **WEB-RF4. Gestión de Activos.**  
  CRUD con bitácora (altas, bajas, movimientos).

- **WEB-RF5. Gestión de Usuarios y Catálogos.**  
  Administración de usuarios, roles, categorías y prioridades.

- **WEB-RF6. Reportes Básicos.**  
  Tickets por estado, técnico o categoría; exportación a CSV y PDF.

### 1.2 Requerimientos No Funcionales (WEB)

- **WEB-RNF1. Seguridad.**  
  Protección antiforgery, bloqueo tras 5 intentos fallidos (15 min), logging estructurado.

---

## 2. API & Microservicios

> **Objetivo:** Backend único que expone contratos REST/JSON + eventos.  
> La Web App MVC y la App Móvil consumen los mismos endpoints.

### 2.1 Autenticación y Control de Acceso

- **API-RF1. JWT.**  
  `POST /auth/token` (grant tipo password, refresh o corporativo).  
- **API-RF2. Autorización por Roles y Claims.**  
  Control de acceso a endpoints según permisos.

---

### 2.2 Contratos de Tickets (MVC y Móvil)

- **API-RF3. Endpoints REST:**
```
GET /v1/tickets?estado&prioridad&tecnicoId&fechaDesde&fechaHasta&pagina&tamanio
POST /v1/tickets ← creación (móvil usa usuario del token)
GET /v1/tickets/{id}
PATCH /v1/tickets/{id} ← cambiar estado/prioridad
POST /v1/tickets/{id}/asignar ← asignar técnico
POST /v1/tickets/{id}/comentarios
POST /v1/tickets/{id}/adjuntos ← subida de archivos (retorna fileId)
```

---

### 2.3 Contratos de Activos y Usuarios

- **API-RF4. Activos.**  
  `GET/POST/PUT /v1/activos` y búsqueda por código o serie.  

- **API-RF5. Usuarios y Catálogos.**  
```
GET/POST /v1/usuarios
GET /v1/catalogos/{nombre}
```

---

### 2.4 Servicio de Archivos (Microservicio Dedicado)

- **API-RF6. Servicio de Archivos.**  
```
POST /v1/files ← subida (con límite de tamaño configurable)
GET /v1/files/{id} ← descarga autorizada con URL firmada temporal
```

---

### 2.5 Notificaciones (Microservicio)

- **API-RF7. Emisión de Eventos.**  
  El servicio de tickets publica:
  - TicketCreated
  - TicketAssigned
  - TicketStatusChanged
  - TicketCommented

- **API-RF8. Entrega Multicanal.**  
  El microservicio de notificaciones consume los eventos y envía:
  - **Push:** FCM / APNS  
  - **Email:** vía SMTP o Graph

---

### 2.6 Contratos y Documentación

- **API-RF9. OpenAPI / Swagger.**  
  Publicación de esquemas, ejemplos y pruebas interactivas.

---

## 3. App Móvil (MAUI / Xamarin)

### 3.1 Requerimientos Funcionales

- **MOB-RF1. Sesión y Contexto.**  
  Inicio de sesión con JWT, persistencia segura y cierre de sesión.

- **MOB-RF2. Bandeja de Tickets.**  
  Vistas:
  - *Asignados a mí*
  - *Hoy*
  - *Pendientes*
  - *Cerrados*  
  Acciones: cambiar estado, comentar, subir evidencia (cámara o galería), registrar tiempo.

- **MOB-RF3. Notificaciones Push.**  
  Recibir alertas en creación, asignación, comentario o cambio de estado.  
  *(Incluye deep-link directo al ticket).*

- **MOB-RF4. Crear Ticket.**  
  Formulario con usuario actual prellenado, categoría, prioridad, adjuntos y geolocalización opcional.

- **MOB-RF5. Activos con Código.**  
  Escaneo QR/Code128 → detalle de activo → nueva intervención o bitácora.

---

## 4. Base de Datos (SQL Server)

### 4.1 Requerimientos Funcionales

- **DB-RF1. Modelo Mínimo.**  
  Tablas principales:
  - Tickets
  - TicketAnotaciones
  - Archivos
  - Usuarios
  - Roles
  - Activos
  - Catalogos
  - Notificaciones

- **DB-RF2. Índices y Búsquedas.**  
  Índices por Estado, TécnicoId, FechaCreacion y búsqueda textual en Asunto/Descripción.

- **DB-RF3. Integridad.**  
  Claves foráneas, validaciones y soft-delete donde aplique.

### 4.2 Requerimientos No Funcionales

- **DB-RNF1. Migraciones.**  
  Migraciones con **EF Core** y datos iniciales (catálogos semilla).

---

## 🏗️ Estructura General

```text
                   ┌────────────────────────────┐
                   │           Cliente           │
                   │ (Usuario Final / Soporte)   │
                   └──────────────┬─────────────┘
                                  │
                    Navegador     │     Dispositivo móvil
                                  │
        ┌─────────────────────────┴─────────────────────────────┐
        ↓                                                         ↓
┌────────────────────────────┐                              ┌────────────────────────────┐
│      Web App MVC           │                              │       App Móvil            │
│ (ASP.NET Core MVC)         │                              │   (.NET MAUI/Xam.)         │
└──────────────┬─────────────┘                              └──────────────┬─────────────┘
               │                 REST/JSON (HTTPS)                         │
               └────────────────────────┬──────────────────────────────────┘
                                        ↓
                         ┌─────────────────────────────────┐
                         │       Web Service API           │
                         │ (ASP.NET Core / REST/JSON)      │
                         └──────────────┬──────────────────┘
                                        │
                                 SQL/EF │
                                        ↓
                         ┌─────────────────────────────────┐
                         │        Base de Datos            │
                         │          SQL Server             │
                         └─────────────────────────────────┘
```

**Descripción:**

- **Cliente:** interactúa tanto con la Web App MVC como con la App Móvil.
- **Web App MVC:** permite gestión, visualización y acciones administrativas.
- **App Móvil:** permite registrar, consultar y recibir notificaciones en campo.
- **Web Service API:** capa central que comunica ambas aplicaciones con la Base de Datos.
- **Base de Datos:** almacena tickets, usuarios, activos y registros de auditoría.

**Notificaciones (Push/Email/Web):**
- Desde Web Service API hacia Web App MVC (bandejas / dashboard)
- Desde Web Service API hacia App Móvil (push con deep-link)

---

## 📌 Nota

Este documento resume los **requisitos funcionales y técnicos** de IndigoAssist.  
El sistema está diseñado bajo un enfoque de **arquitectura desacoplada**, donde:
- MVC y Móvil comparten el mismo backend (API REST).
- Los microservicios manejan eventos y tareas asincrónicas.
- La escalabilidad y mantenimiento están soportados por capas bien definidas.

---

## 🌐 Contexto del Proyecto — IndigoAssist

Actualmente, la organización cuenta con un **sistema legacy** para la gestión de tickets de soporte, desarrollado en **ASP.NET WebForms**.  
Este sistema comunica los eventos de soporte **únicamente a través de correos electrónicos**.  
Cada vez que se crea un ticket, se asigna un técnico o se añade una anotación, el sistema envía notificaciones por correo tanto al usuario que abrió el ticket como al técnico asignado.  
Sin embargo, los técnicos **solo reciben notificaciones iniciales**, y no en los cambios posteriores de estado o seguimiento.

La revisión de métricas de desempeño (KPI) requiere un proceso manual: cada mes es necesario analizar la información histórica de los tickets, lo que **consume alrededor de 30 minutos por revisión**, dificultando la toma de decisiones ágiles y la detección temprana de incidencias o cuellos de botella.

Con **IndigoAssist**, se busca modernizar este entorno mediante una **arquitectura basada en servicios y aplicaciones desacopladas**, con el siguiente enfoque:

---

### 🌐 Aplicación Web (MVC)
La nueva **aplicación web desarrollada en ASP.NET Core MVC** permitirá una visualización centralizada y dinámica de la información de soporte.  
Entre sus beneficios clave se encuentran:
- Control y seguimiento en tiempo real de los tickets.  
- Visualización de indicadores de rendimiento (tiempo de atención, cumplimiento de SLA, antigüedad de tickets).  
- Reducción del uso de correos mediante un dashboard interactivo y notificaciones internas.  
- Mayor eficiencia en la gestión de incidencias y priorización de tareas.

Adicionalmente, la aplicación web integrará un **módulo de gestión de activos**, reemplazando el control manual que actualmente se lleva en hojas de cálculo de Excel.  
Este módulo permitirá:
- Registrar equipos, usuarios responsables y estados de garantía.  
- Gestionar fechas de renovación, mantenimientos y reportes de fallas.  
- Relacionar activos directamente con los tickets de soporte, mejorando la trazabilidad.

---

### 📱 Aplicación Móvil
La **aplicación móvil (MAUI/Xamarin)** está orientada a mejorar la **comunicación operativa** entre técnicos y usuarios en campo.  
Permitirá:
- Recibir **notificaciones push** al crearse, asignarse o actualizarse un ticket.  
- Eliminar la dependencia del correo electrónico, evitando mensajes ignorados o retrasados.  
- Crear y actualizar tickets directamente desde el dispositivo móvil, con posibilidad de adjuntar fotos o comentarios de seguimiento.

Esta app busca **acelerar la respuesta** ante incidencias y mantener sincronizada la información en tiempo real.

---

### 🔌 Servicio Web API
El **Web Service API (REST/JSON)** funcionará como **núcleo central de comunicación** entre todas las capas del sistema.  
Sus principales objetivos son:
- Centralizar la lógica de negocio y las operaciones de acceso a datos.  
- Evitar duplicación de código entre la aplicación web y móvil.  
- Facilitar la expansión futura del sistema (por ejemplo, integración con bots o dashboards BI).  
- Permitir escalabilidad modular mediante microservicios (notificaciones, auditoría, SLA engine, etc.).

Gracias a esta capa, las aplicaciones cliente podrán enfocarse únicamente en su presentación, mientras el API gestiona las consultas, validaciones y sincronización con la base de datos.

---

### 💾 Base de Datos
La **base de datos** mantendrá compatibilidad con el esquema existente del sistema legacy, preservando la información histórica de tickets.  
A la vez, se agregarán nuevas tablas dedicadas al módulo de activos y auditorías, sin alterar los procesos actuales.

También se implementará una estrategia de **limpieza y optimización de archivos**, ya que actualmente existe una base de datos dedicada a imágenes asociadas a tickets.  
Se propone eliminar los archivos con más de **tres años de antigüedad**, liberando espacio y evaluando alternativas para un **almacenamiento más eficiente** (como File System o Blob Storage).

---

### 🎯 Beneficios Esperados
- Reducción de la carga administrativa y del tiempo de revisión de KPIs.  
- Comunicación más ágil y efectiva entre usuarios y técnicos.  
- Centralización de la información y reducción de errores por duplicidad.  
- Migración progresiva del sistema legacy hacia una plataforma moderna, escalable y mantenible.  
- Mayor trazabilidad de activos, incidencias y métricas operativas.

---

**En resumen**, IndigoAssist busca unificar la gestión de soporte y activos en una plataforma moderna, optimizando la comunicación, el control y la eficiencia operativa mediante el uso conjunto de tecnologías **MVC, MAUI y API REST** sobre una **base de datos unificada y evolutiva**.

---

# 👥 Historias de Usuario — IndigoAssist

> Cada historia describe un proceso funcional clave del sistema, con sus **prerrequisitos**, **pasos** y **siguientes pasos**.

---

<details>
<summary>🔐 Iniciar sesión</summary>

**Descripción:**  
El usuario (técnico, administrador o mesa de ayuda) ingresa sus credenciales para autenticarse en el sistema, ya sea desde la web o la app móvil.

**Prerrequisitos:**  
El usuario debe tener una cuenta activa y conocer su correo y contraseña.

**Pasos:**
- El usuario ingresa correo y contraseña en el formulario de inicio.  
- El sistema envía la solicitud a `/auth/token`.  
- La API valida credenciales, rol y estado del usuario.  
- Si son correctas, devuelve un **JWT** con los permisos asociados.  
- La aplicación almacena el token localmente (seguro o en sesión).  
- Se redirige al panel principal o dashboard correspondiente a su rol.

**Siguientes pasos:**  
El usuario puede acceder a la pantalla de **Dashboard** o **Gestión de Tickets**.

</details>

---

<details>
<summary>👤➕ Crear usuarios (solo administradores)</summary>

**Descripción:**  
El administrador podrá registrar nuevos usuarios técnicos o de mesa de ayuda dentro del sistema.

**Prerrequisitos:**  
El usuario actual debe tener el rol **Administrador** y haber iniciado sesión.

**Pasos:**
- El administrador accede al módulo **Usuarios → Crear nuevo**.  
- Ingresa: nombre, correo, rol, sucursal y contraseña inicial.  
- El sistema valida si existe un usuario en el sistema legacy.  
- Si no existe, crea el registro en las tablas del sistema legacy.  
- Notifica de la creación del usuario en el mismo sistema.

**Siguientes pasos:**  
El nuevo usuario podrá **iniciar sesión** con las credenciales asignadas.

</details>

---

<details>
<summary>📊 Ver dashboard con información de tickets</summary>

**Descripción:**  
El usuario visualiza un panel con métricas y tickets agrupados por estado, prioridad o técnico.

**Prerrequisitos:**  
El usuario debe haber iniciado sesión correctamente.

**Pasos:**
- El usuario accede al menú "Dashboard".  
- El sistema consulta la API `/v1/tickets?estado&prioridad&tecnicoId`.  
- La API devuelve métricas calculadas por tiempo.  
- Se muestran indicadores y tarjetas con tickets agrupados.  
- El usuario puede filtrar por rango de fechas, categoría o sucursal.

**Siguientes pasos:**  
El usuario puede **abrir un ticket**, **reasignarlo** o **editar sus anotaciones**.

</details>

---

<details>
<summary>🎫 Tomar un ticket y editar sus anotaciones</summary>

**Descripción:**  
El técnico toma responsabilidad de un ticket y puede agregar observaciones o avances.

**Prerrequisitos:**  
El usuario debe tener rol **Técnico** o **Mesa de ayuda**, y el ticket debe estar en estado *Nuevo* o *Asignado*.

**Pasos:**
- El usuario abre el ticket desde su listado.  
- Da clic en "Tomar Ticket" → llamada a `/v1/tickets/{id}/asignar`.  
- El sistema registra el técnico asignado y actualiza el estado.  
- El técnico agrega anotaciones desde `/v1/tickets/{id}/anotaciones`.  
- La API guarda los registros en `TicketAnotaciones`.  
- Se genera un evento `TicketAssigned` o `TicketCommented`.  

**Siguientes pasos:**  
El usuario puede **subir evidencia** o **cambiar el estado** del ticket.

</details>

---

<details>
<summary>📸 Subir evidencia a un ticket</summary>

**Descripción:**  
El técnico puede adjuntar fotos o archivos como evidencia del avance o cierre del ticket.

**Prerrequisitos:**  
Debe existir un ticket abierto y el técnico debe tener permisos de edición sobre él.

**Pasos:**
- El usuario selecciona "Agregar evidencia" dentro del ticket.  
- El sistema abre el explorador de archivos o cámara.  
- El archivo se envía a `/v1/files` (verifica tipo y tamaño).  
- La API guarda la evidencia y devuelve un `fileId`.  
- Se vincula el archivo al ticket mediante `/v1/tickets/{id}/adjuntos`.  
- Se publica un evento `TicketCommented` con la evidencia agregada.

**Siguientes pasos:**  
El técnico puede **cambiar el estado a "En proceso" o "Resuelto"**.

</details>

---

<details>
<summary>🖥️ Crear activos</summary>

**Descripción:**  
Permite registrar nuevos activos dentro del inventario, vinculables posteriormente a tickets.

**Prerrequisitos:**  
El usuario debe tener rol **Administrador**

**Pasos:**
- Acceder al módulo **Activos → Nuevo**.  
- Capturar datos: código, tipo, marca, modelo, serie, ubicación, Usuario Asignado.  
- La API valida que el código o serie no existan duplicados.  
- Guarda el registro en la tabla `Activos`.  
- Crea entrada inicial en `ActivosBitacora`.

**Siguientes pasos:**  
El activo podrá ser **asignado a un usuario** o **vinculado a un ticket**.

</details>

---

<details>
<summary>✏️ Editar activos</summary>

**Descripción:**  
Permite actualizar la información de un activo o cambiar su estado operativo.

**Prerrequisitos:**  
Debe existir el activo y el usuario debe tener permisos de edición.

**Pasos:**
- Buscar el activo por código o serie.  
- Editar campos permitidos (estado, Usuario Asignado).  
- Confirmar los cambios y enviar a `/v1/activos/{id}` (PUT).  
- La API valida integridad y registra la modificación en `ActivosBitacora`.

**Siguientes pasos:**  
El usuario puede **asignar el activo** a otro Usuario Asignado o **vincularlo a un ticket**.

</details>

---

<details>
<summary>👥 Asignar activos</summary>

**Descripción:**  
Permite asignar un activo a un usuario o técnico para su uso.

**Prerrequisitos:**  
Debe existir el activo y el usuario destino en el sistema.

**Pasos:**
- Desde el módulo de activos, seleccionar "Asignar".  
- Elegir usuario destino y ubicación.  
- Enviar solicitud a `/v1/activos/{id}/asignar`.  
- La API valida disponibilidad y actualiza custodio en `Activos`.  
- Registra la transacción en `ActivosBitacora`.  
- Notifica al usuario asignado (correo o push).

**Siguientes pasos:**  
El activo queda disponible para **vincularse a tickets** o **ser auditado** en reportes.

</details>

---