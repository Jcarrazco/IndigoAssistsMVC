# ?? Lista de Requisitos �� Proyecto IndigoAssist

## 1. App Web (ASP.NET Core MVC)

### 1.1 Requerimientos Funcionales

- **WEB-RF1. Autenticaci��n y Roles.**  
  Inicio de sesi��n, cierre, recuperaci��n; autorizaci��n por rol (Administrador, Mesa de Ayuda, T��cnico, Auditor).

- **WEB-RF2. Gesti��n de Tickets.**  
  - CRUD: solicitante, categor��a, prioridad, estado, t��cnico, SLA, adjuntos.  
  - Filtros combinables: estado, prioridad, t��cnico, fecha, sucursal.  
  - Acciones masivas: reasignar, cambiar estado, cerrar.

- **WEB-RF3. Dashboard Accionable.**  
  - Vistas: vencidos, pr��ximos a vencer, en espera del usuario.  
  - Acciones r��pidas en tarjeta: reasignar, comentar, cerrar.

- **WEB-RF4. Gesti��n de Activos.**  
  CRUD con bit��cora (altas, bajas, movimientos).

- **WEB-RF5. Gesti��n de Usuarios y Cat��logos.**  
  Administraci��n de usuarios, roles, categor��as y prioridades.

- **WEB-RF6. Reportes B��sicos.**  
  Tickets por estado, t��cnico o categor��a; exportaci��n a CSV y PDF.

### 1.2 Requerimientos No Funcionales (WEB)

- **WEB-RNF1. Seguridad.**  
  Protecci��n antiforgery, bloqueo tras 5 intentos fallidos (15 min), logging estructurado.

---

## 2. API & Microservicios

> **Objetivo:** Backend ��nico que expone contratos REST/JSON + eventos.  
> La Web App MVC y la App M��vil consumen los mismos endpoints.

### 2.1 Autenticaci��n y Control de Acceso

- **API-RF1. JWT.**  
  `POST /auth/token` (grant tipo password, refresh o corporativo).  
- **API-RF2. Autorizaci��n por Roles y Claims.**  
  Control de acceso a endpoints seg��n permisos.

---

### 2.2 Contratos de Tickets (MVC y M��vil)

- **API-RF3. Endpoints REST:**
GET /v1/tickets?estado&prioridad&tecnicoId&fechaDesde&fechaHasta&pagina&tamanio
POST /v1/tickets �� creaci��n (m��vil usa usuario del token)
GET /v1/tickets/{id}
PATCH /v1/tickets/{id} �� cambiar estado/prioridad
POST /v1/tickets/{id}/asignar �� asignar t��cnico
POST /v1/tickets/{id}/comentarios
POST /v1/tickets/{id}/adjuntos �� subida de archivos (retorna fileId)

---

### 2.3 Contratos de Activos y Usuarios

- **API-RF4. Activos.**  
`GET/POST/PUT /v1/activos` y b��squeda por c��digo o serie.  

- **API-RF5. Usuarios y Cat��logos.**  

---

### 2.3 Contratos de Activos y Usuarios

- **API-RF4. Activos.**  
`GET/POST/PUT /v1/activos` y b��squeda por c��digo o serie.  

- **API-RF5. Usuarios y Cat��logos.**  
GET/POST /v1/usuarios
GET /v1/catalogos/{nombre}

---

### 2.4 Servicio de Archivos (Microservicio Dedicado)

- **API-RF6. Servicio de Archivos.**  
POST /v1/files �� subida (con l��mite de tama?o configurable)
GET /v1/files/{id} �� descarga autorizada con URL firmada temporal

---

### 2.5 Notificaciones (Microservicio)

- **API-RF7. Emisi��n de Eventos.**  
El servicio de tickets publica:
TicketCreated
TicketAssigned
TicketStatusChanged
TicketCommented

- **API-RF8. Entrega Multicanal.**  
El microservicio de notificaciones consume los eventos y env��a:
- **Push:** FCM / APNS  
- **Email:** v��a SMTP o Graph

---

### 2.6 Contratos y Documentaci��n

- **API-RF9. OpenAPI / Swagger.**  
Publicaci��n de esquemas, ejemplos y pruebas interactivas.

---

## 3. App M��vil (MAUI / Xamarin)

### 3.1 Requerimientos Funcionales

- **MOB-RF1. Sesi��n y Contexto.**  
Inicio de sesi��n con JWT, persistencia segura y cierre de sesi��n.

- **MOB-RF2. Bandeja de Tickets.**  
Vistas:
- *Asignados a m��*
- *Hoy*
- *Pendientes*
- *Cerrados*  
Acciones: cambiar estado, comentar, subir evidencia (c��mara o galer��a), registrar tiempo.

- **MOB-RF3. Notificaciones Push.**  
Recibir alertas en creaci��n, asignaci��n, comentario o cambio de estado.  
*(Incluye deep-link directo al ticket).*

- **MOB-RF4. Crear Ticket.**  
Formulario con usuario actual prellenado, categor��a, prioridad, adjuntos y geolocalizaci��n opcional.

- **MOB-RF5. Activos con C��digo.**  
Escaneo QR/Code128 �� detalle de activo �� nueva intervenci��n o bit��cora.

---

## 4. Base de Datos (SQL Server)

### 4.1 Requerimientos Funcionales

- **DB-RF1. Modelo M��nimo.**  
Tablas principales:
Tickets
TicketAnotaciones
Archivos
Usuarios
Roles
Activos
Catalogos
Notificaciones


- **DB-RF2. ��ndices y B��squedas.**  
��ndices por Estado, T��cnicoId, FechaCreacion y b��squeda textual en Asunto/Descripci��n.

- **DB-RF3. Integridad.**  
Claves for��neas, validaciones y soft-delete donde aplique.

### 4.2 Requerimientos No Funcionales

- **DB-RNF1. Migraciones.**  
Migraciones con **EF Core** y datos iniciales (cat��logos semilla).

---

## ?? Estructura General


```text
                   ��������������������������������������������������������������
                   ��           Cliente           ��
                   �� (Usuario Final / Soporte)   ��
                   ���������������������������������Щ���������������������������
                                   ��
                     Navegador     ��     Dispositivo m��vil
                                   ��
        �������������������������������������������������������੤������������������������������������������������������
        ��                                                      ��
��������������������������������������������������                              ��������������������������������������������������
��      Web App MVC      ��                              ��       App M��vil       ��
�� (ASP.NET Core MVC)    ��                              ��   (.NET MAUI/Xam.)   ��
�������������������������Щ�����������������������                              �������������������������Щ���������������������
            ��                 REST/JSON (HTTPS)                    ��
            �����������������������������������������������Щ���������������������������������������������������������������
                                   ��
                         ��������������������������������������������������������������
                         ��       Web Service API       ��
                         �� (ASP.NET Core / REST/JSON)  ��
                         �������������������������Щ�����������������������������������
                                     ��
                              SQL/EF  ��
                                     ��
                         ��������������������������������������������������������������
                         ��        Base de Datos        ��
                         ��          SQL Server         ��
                         ��������������������������������������������������������������
Descripci��n:

Cliente: interact��a tanto con la Web App MVC como con la App M��vil.

Web App MVC: permite gesti��n, visualizaci��n y acciones administrativas.

App M��vil: permite registrar, consultar y recibir notificaciones en campo.

Web Service API: capa central que comunica ambas aplicaciones con la Base de Datos.

Base de Datos: almacena tickets, usuarios, activos y registros de auditor��a.

Notificaciones (Push/Email/Web) ������������������������������������������������������������������������������������?
  - Desde Web Service API hacia Web App MVC (bandejas / dashboard)
  - Desde Web Service API hacia App M��vil (push con deep-link)


---

## ?? Nota

Este documento resume los **requisitos funcionales y t��cnicos** de IndigoAssist.  
El sistema est�� dise?ado bajo un enfoque de **arquitectura desacoplada**, donde:
- MVC y M��vil comparten el mismo backend (API REST).
- Los microservicios manejan eventos y tareas asincr��nicas.
- La escalabilidad y mantenimiento est��n soportados por capas bien definidas.



## ?? Contexto del Proyecto �� IndigoAssist

Actualmente, la organizaci��n cuenta con un **sistema legacy** para la gesti��n de tickets de soporte, desarrollado en **ASP.NET WebForms**.  
Este sistema comunica los eventos de soporte **��nicamente a trav��s de correos electr��nicos**.  
Cada vez que se crea un ticket, se asigna un t��cnico o se a?ade una anotaci��n, el sistema env��a notificaciones por correo tanto al usuario que abri�� el ticket como al t��cnico asignado.  
Sin embargo, los t��cnicos **solo reciben notificaciones iniciales**, y no en los cambios posteriores de estado o seguimiento.

La revisi��n de m��tricas de desempe?o (KPI) requiere un proceso manual: cada mes es necesario analizar la informaci��n hist��rica de los tickets, lo que **consume alrededor de 30 minutos por revisi��n**, dificultando la toma de decisiones ��giles y la detecci��n temprana de incidencias o cuellos de botella.

Con **IndigoAssist**, se busca modernizar este entorno mediante una **arquitectura basada en servicios y aplicaciones desacopladas**, con el siguiente enfoque:

---

### ?? Aplicaci��n Web (MVC)
La nueva **aplicaci��n web desarrollada en ASP.NET Core MVC** permitir�� una visualizaci��n centralizada y din��mica de la informaci��n de soporte.  
Entre sus beneficios clave se encuentran:
- Control y seguimiento en tiempo real de los tickets.  
- Visualizaci��n de indicadores de rendimiento (tiempo de atenci��n, cumplimiento de SLA, antig��edad de tickets).  
- Reducci��n del uso de correos mediante un dashboard interactivo y notificaciones internas.  
- Mayor eficiencia en la gesti��n de incidencias y priorizaci��n de tareas.

Adicionalmente, la aplicaci��n web integrar�� un **m��dulo de gesti��n de activos**, reemplazando el control manual que actualmente se lleva en hojas de c��lculo de Excel.  
Este m��dulo permitir��:
- Registrar equipos, usuarios responsables y estados de garant��a.  
- Gestionar fechas de renovaci��n, mantenimientos y reportes de fallas.  
- Relacionar activos directamente con los tickets de soporte, mejorando la trazabilidad.

---

### ?? Aplicaci��n M��vil
La **aplicaci��n m��vil (MAUI/Xamarin)** est�� orientada a mejorar la **comunicaci��n operativa** entre t��cnicos y usuarios en campo.  
Permitir��:
- Recibir **notificaciones push** al crearse, asignarse o actualizarse un ticket.  
- Eliminar la dependencia del correo electr��nico, evitando mensajes ignorados o retrasados.  
- Crear y actualizar tickets directamente desde el dispositivo m��vil, con posibilidad de adjuntar fotos o comentarios de seguimiento.

Esta app busca **acelerar la respuesta** ante incidencias y mantener sincronizada la informaci��n en tiempo real.

---

### ?? Servicio Web API
El **Web Service API (REST/JSON)** funcionar�� como **n��cleo central de comunicaci��n** entre todas las capas del sistema.  
Sus principales objetivos son:
- Centralizar la l��gica de negocio y las operaciones de acceso a datos.  
- Evitar duplicaci��n de c��digo entre la aplicaci��n web y m��vil.  
- Facilitar la expansi��n futura del sistema (por ejemplo, integraci��n con bots o dashboards BI).  
- Permitir escalabilidad modular mediante microservicios (notificaciones, auditor��a, SLA engine, etc.).

Gracias a esta capa, las aplicaciones cliente podr��n enfocarse ��nicamente en su presentaci��n, mientras el API gestiona las consultas, validaciones y sincronizaci��n con la base de datos.

---

### ??? Base de Datos
La **base de datos** mantendr�� compatibilidad con el esquema existente del sistema legacy, preservando la informaci��n hist��rica de tickets.  
A la vez, se agregar��n nuevas tablas dedicadas al m��dulo de activos y auditor��as, sin alterar los procesos actuales.

Tambi��n se implementar�� una estrategia de **limpieza y optimizaci��n de archivos**, ya que actualmente existe una base de datos dedicada a im��genes asociadas a tickets.  
Se propone eliminar los archivos con m��s de **tres a?os de antig��edad**, liberando espacio y evaluando alternativas para un **almacenamiento m��s eficiente** (como File System o Blob Storage).

---

### ?? Beneficios Esperados
- Reducci��n de la carga administrativa y del tiempo de revisi��n de KPIs.  
- Comunicaci��n m��s ��gil y efectiva entre usuarios y t��cnicos.  
- Centralizaci��n de la informaci��n y reducci��n de errores por duplicidad.  
- Migraci��n progresiva del sistema legacy hacia una plataforma moderna, escalable y mantenible.  
- Mayor trazabilidad de activos, incidencias y m��tricas operativas.

---

**En resumen**, IndigoAssist busca unificar la gesti��n de soporte y activos en una plataforma moderna, 
optimizando la comunicaci��n, el control y la eficiencia operativa mediante el uso conjunto de tecnolog��as **MVC, MAUI y API REST** sobre una **base de datos unificada y evolutiva**.



# ?? Historias de Usuario �� IndigoAssist

> Cada historia describe un proceso funcional clave del sistema, con sus **prerrequisitos**, **pasos** y **siguientes pasos**.

---

<details>
<summary>?? Iniciar sesi��n</summary>

**Descripci��n:**  
El usuario (t��cnico, administrador o mesa de ayuda) ingresa sus credenciales para autenticarse en el sistema, ya sea desde la web o la app m��vil.

**Prerrequisitos:**  
El usuario debe tener una cuenta activa y conocer su correo y contrase?a.

**Pasos:**
- El usuario ingresa correo y contrase?a en el formulario de inicio.  
- El sistema env��a la solicitud a `/auth/token`.  
- La API valida credenciales, rol y estado del usuario.  
- Si son correctas, devuelve un **JWT** con los permisos asociados.  
- La aplicaci��n almacena el token localmente (seguro o en sesi��n).  
- Se redirige al panel principal o dashboard correspondiente a su rol.

**Siguientes pasos:**  
El usuario puede acceder a la pantalla de **Dashboard** o **Gesti��n de Tickets**.

</details>

---

<details>
<summary>????? Crear usuarios (solo administradores)</summary>

**Descripci��n:**  
El administrador podr�� registrar nuevos usuarios t��cnicos o de mesa de ayuda dentro del sistema.

**Prerrequisitos:**  
El usuario actual debe tener el rol **Administrador** y haber iniciado sesi��n.

**Pasos:**
- El administrador accede al m��dulo **Usuarios �� Crear nuevo**.  
- Ingresa: nombre, correo, rol, sucursal y contrase?a inicial.  
- El sistema valida si existe un usuario en el sistema legacy.  
- Si no existe, crea el registro en las tablas del sistema legacy.  
- Notifica de la creacion del usuario en el mismo sistema.

**Siguientes pasos:**  
El nuevo usuario podr�� **iniciar sesi��n** con las credenciales asignadas.

</details>

---

<details>
<summary>?? Ver dashboard con informaci��n de tickets</summary>

**Descripci��n:**  
El usuario visualiza un panel con m��tricas y tickets agrupados por estado, prioridad o t��cnico.

**Prerrequisitos:**  
El usuario debe haber iniciado sesi��n correctamente.

**Pasos:**
- El usuario accede al men�� ��Dashboard��.  
- El sistema consulta la API `/v1/tickets?estado&prioridad&tecnicoId`.  
- La API devuelve m��tricas calculadas por tiempo.  
- Se muestran indicadores y tarjetas con tickets agrupados.  
- El usuario puede filtrar por rango de fechas, categor��a o sucursal.

**Siguientes pasos:**  
El usuario puede **abrir un ticket**, **reasignarlo** o **editar sus anotaciones**.

</details>

---

<details>
<summary>?? Tomar un ticket y editar sus anotaciones</summary>

**Descripci��n:**  
El t��cnico toma responsabilidad de un ticket y puede agregar observaciones o avances.

**Prerrequisitos:**  
El usuario debe tener rol **T��cnico** o **Mesa de ayuda**, y el ticket debe estar en estado *Nuevo* o *Asignado*.

**Pasos:**
- El usuario abre el ticket desde su listado.  
- Da clic en ��Tomar Ticket�� �� llamada a `/v1/tickets/{id}/asignar`.  
- El sistema registra el t��cnico asignado y actualiza el estado.  
- El t��cnico agrega anotaciones desde `/v1/tickets/{id}/anotaciones`.  
- La API guarda los registros en `TicketAnotaciones`.  
- Se genera un evento `TicketAssigned` o `TicketCommented`.  

**Siguientes pasos:**  
El usuario puede **subir evidencia** o **cambiar el estado** del ticket.

</details>

---

<details>
<summary>?? Subir evidencia a un ticket</summary>

**Descripci��n:**  
El t��cnico puede adjuntar fotos o archivos como evidencia del avance o cierre del ticket.

**Prerrequisitos:**  
Debe existir un ticket abierto y el t��cnico debe tener permisos de edici��n sobre ��l.

**Pasos:**
- El usuario selecciona ��Agregar evidencia�� dentro del ticket.  
- El sistema abre el explorador de archivos o c��mara.  
- El archivo se env��a a `/v1/files` (verifica tipo y tama?o).  
- La API guarda la evidencia y devuelve un `fileId`.  
- Se vincula el archivo al ticket mediante `/v1/tickets/{id}/adjuntos`.  
- Se publica un evento `TicketCommented` con la evidencia agregada.

**Siguientes pasos:**  
El t��cnico puede **cambiar el estado a ��En proceso�� o ��Resuelto��**.

</details>

---

<details>
<summary>?? Crear activos</summary>

**Descripci��n:**  
Permite registrar nuevos activos dentro del inventario, vinculables posteriormente a tickets.

**Prerrequisitos:**  
El usuario debe tener rol **Administrador**

**Pasos:**
- Acceder al m��dulo **Activos �� Nuevo**.  
- Capturar datos: c��digo, tipo, marca, modelo, serie, ubicaci��n, Usuario Asignado.  
- La API valida que el c��digo o serie no existan duplicados.  
- Guarda el registro en la tabla `Activos`.  
- Crea entrada inicial en `ActivosBitacora`.

**Siguientes pasos:**  
El activo podr�� ser **asignado a un usuario** o **vinculado a un ticket**.

</details>

---

<details>
<summary>?? Editar activos</summary>

**Descripci��n:**  
Permite actualizar la informaci��n de un activo o cambiar su estado operativo.

**Prerrequisitos:**  
Debe existir el activo y el usuario debe tener permisos de edici��n.

**Pasos:**
- Buscar el activo por c��digo o serie.  
- Editar campos permitidos (estado, Usuario Asignado).  
- Confirmar los cambios y enviar a `/v1/activos/{id}` (PUT).  
- La API valida integridad y registra la modificaci��n en `ActivosBitacora`.

**Siguientes pasos:**  
El usuario puede **asignar el activo** a otro Usuario Asignado o **vincularlo a un ticket**.

</details>

---

<details>
<summary>?? Asignar activos</summary>

**Descripci��n:**  
Permite asignar un activo a un usuario o t��cnico para su uso.

**Prerrequisitos:**  
Debe existir el activo y el usuario destino en el sistema.

**Pasos:**
- Desde el m��dulo de activos, seleccionar ��Asignar��.  
- Elegir usuario destino y ubicaci��n.  
- Enviar solicitud a `/v1/activos/{id}/asignar`.  
- La API valida disponibilidad y actualiza custodio en `Activos`.  
- Registra la transacci��n en `ActivosBitacora`.  
- Notifica al usuario asignado (correo o push).

**Siguientes pasos:**  
El activo queda disponible para **vincularse a tickets** o **ser auditado** en reportes.

</details>

---
