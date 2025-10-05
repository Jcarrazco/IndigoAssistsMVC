# Diagrama de Relaciones del Sistema de Tickets

## Diagrama Entidad-Relación

```
┌─────────────────────┐
│    mEmpresas        │ (Dependencia Externa)
│  - IdEmpresa (PK)   │
└──────────┬──────────┘
           │
           │ IdEmpresa
           ▼
┌─────────────────────┐
│    mPersonas        │ (Dependencia Externa)
│  - Persona (PK)     │
└──────────┬──────────┘
           │
           │ Persona
           ▼
┌─────────────────────┐                    ┌─────────────────────┐
│     mPerEmp         │                    │   mEmpleados        │
│  - IdPersona (PK)   │◄───────────────────┤  - IdPersona (PK)   │
│  - IdEmpresa (FK)   │   IdPersona        │  - Login            │
│  - Persona (FK)     │                    │  - Activo           │
└──────────┬──────────┘                    └──────────┬──────────┘
           │                                          │
           │ Usuario                                  │
           │                                          │ IdPersona
           ▼                                          ▼
┌─────────────────────────────────────┐    ┌─────────────────────┐
│          mTickets                   │    │   dTicketsTecnicos  │
│  - IdTicket (PK)                    │◄───┤  - IdTicket (PK,FK) │
│  - Usuario (FK → mPerEmp)           │    │  - IdPersona (PK,FK)│
│  - IdSubCategoria (FK)              │    └─────────────────────┘
│  - Titulo                           │
│  - Descripcion                      │
│  - Status (FK)                      │
│  - IdTipoTicket (FK)                │
│  - Prioridad (FK)                   │
│  - FeAlta                           │
│  - FeAsignacion                     │
│  - FeCompromiso                     │
│  - FeCierre                         │
└──────────┬──────────────────────────┘
           │
           │ IdTicket
           │
           ├────────────────────────┐
           │                        │
           ▼                        ▼
┌─────────────────────┐  ┌─────────────────────┐
│     dTickets        │  │  mValoracionTicket  │
│  - IdDTicket (PK)   │  │  - IdTicket         │
│  - IdTicket (FK)    │  │  - Fecha            │
│  - Evento           │  │  - Valoracion       │
│  - Tiempo           │  │  - Comentario       │
│  - Fecha            │  └─────────────────────┘
│  - Usuario          │
└─────────────────────┘


┌─────────────────────┐
│  mDepartamentos     │
│  - IdDepto (PK)     │
│  - Departamento     │
│  - Tickets          │
└──────────┬──────────┘
           │
           │ IdDepto
           │
           ├────────────────────┐
           │                    │
           ▼                    ▼
┌─────────────────────┐  ┌─────────────────────┐
│     mPuestos        │  │ mCategoriasTicket   │
│  - IdPuesto (PK)    │  │  - IdCategoria (PK) │
│  - Puesto           │  │  - Categoria        │
│  - IdDepto (FK)     │  │  - IdDepto (FK)     │
└──────────┬──────────┘  └──────────┬──────────┘
           │                        │
           │ IdPuesto               │ IdCategoria
           ▼                        ▼
┌─────────────────────┐  ┌──────────────────────────┐
│    dEmpleados       │  │  mSubCategoriasTicket    │
│  - IdPersona        │  │  - IdSubCategoria (PK)   │
│  - IdPuesto (FK)    │  │  - SubCategoria          │
│  - Principal        │  │  - IdCategoria (FK)      │
└─────────────────────┘  └──────────┬───────────────┘
                                    │
                                    │ IdSubCategoria
                                    │
                                    └──────► (Usado en mTickets)


┌─────────────────────┐
│  mStatusTicket      │
│  - Status (PK)      │
│  - StatusDes        │
└──────────┬──────────┘
           │
           │ Status
           └──────► (Usado en mTickets)


┌─────────────────────┐
│ mPrioridadTicket    │
│  - IdPrioridad (PK) │
│  - Prioridad        │
└──────────┬──────────┘
           │
           │ Prioridad
           └──────► (Usado en mTickets)


┌─────────────────────┐
│   mTipoTicket       │
│  - IdTipoTicket(PK) │
│  - TipoTicket       │
└──────────┬──────────┘
           │
           │ IdTipoTicket
           └──────► (Usado en mTickets)
```

## Tablas Históricas (Espejo de las activas)

```
┌─────────────────────────────────────┐
│          hTickets                   │
│  - IdTicket (PK)                    │
│  - Usuario (FK → mPerEmp)           │
│  - IdSubCategoria (FK)              │
│  - Titulo                           │
│  - Descripcion                      │
│  - IdTipoTicket (FK)                │
│  - Prioridad (FK)                   │
│  - FeAlta                           │
│  - FeAsignacion                     │
│  - FeCompromiso                     │
│  - FeCierre                         │
└──────────┬──────────────────────────┘
           │
           │ IdTicket
           │
           ├────────────────────┐
           │                    │
           ▼                    ▼
┌─────────────────────┐  ┌─────────────────────┐
│     hdTickets       │  │ hdTicketsTecnicos   │
│  - IdDTicket (PK)   │  │  - IdTicket (FK)    │
│  - IdTicket (FK)    │  │  - IdPersona (FK)   │
│  - Evento           │  └─────────────────────┘
│  - Tiempo           │
│  - Fecha            │
│  - Usuario          │
└─────────────────────┘
```

## Vistas Principales

### vEmpleados
```sql
SELECT 
    mEmpleados.IdPersona,
    mEmpleados.Login,
    mEmpleados.Activo,
    dEmpleados.IdPuesto,
    mPuestos.Puesto,
    dEmpleados.Principal,
    mPuestos.IdDepto,
    mDepartamentos.Departamento,
    mDepartamentos.Tickets
FROM mEmpleados 
INNER JOIN dEmpleados ON mEmpleados.IdPersona = dEmpleados.IdPersona
INNER JOIN mPuestos ON dEmpleados.IdPuesto = mPuestos.IdPuesto
INNER JOIN mDepartamentos ON mPuestos.IdDepto = mDepartamentos.IdDepto
```

### vTickets (Vista completa de tickets activos)
```sql
SELECT 
    mTickets.IdTicket,
    mTickets.Usuario AS IdSolicitante,
    mEmpleados.Login AS Solicitante,
    dTicketsTecnicos.IdPersona AS IdTecnico,
    [Login del Técnico] AS Tecnico,
    mTickets.Titulo,
    mTickets.Descripcion,
    mStatusTicket.Status,
    mStatusTicket.StatusDes,
    mTickets.IdTipoTicket,
    mTickets.Prioridad AS IdPrioridad,
    mTickets.FeAlta,
    mTickets.FeAsignacion,
    mTickets.FeCompromiso,
    mTickets.FeCierre,
    mSubCategoriasTicket.IdSubCategoria,
    mSubCategoriasTicket.SubCategoria,
    mCategoriasTicket.IdCategoria,
    mCategoriasTicket.Categoria,
    mDepartamentos.IdDepto,
    mDepartamentos.Departamento
FROM mTickets 
INNER JOIN mEmpleados ON mTickets.Usuario = mEmpleados.IdPersona
INNER JOIN mSubCategoriasTicket ON mTickets.IdSubCategoria = mSubCategoriasTicket.IdSubCategoria
INNER JOIN mCategoriasTicket ON mSubCategoriasTicket.IdCategoria = mCategoriasTicket.IdCategoria
INNER JOIN mDepartamentos ON mCategoriasTicket.IdDepto = mDepartamentos.IdDepto
INNER JOIN mStatusTicket ON mTickets.Status = mStatusTicket.Status
LEFT OUTER JOIN dTicketsTecnicos ON mTickets.IdTicket = dTicketsTecnicos.IdTicket
```

### vhTickets (Vista completa de tickets históricos)
Similar a vTickets pero usando las tablas históricas (hTickets, hdTicketsTecnicos)

## Flujo de Datos

### 1. Creación de Ticket
```
Usuario (mPerEmp) → Crea → mTickets
                              │
                              ├─ Define: SubCategoría (mSubCategoriasTicket)
                              ├─ Define: Prioridad (mPrioridadTicket)
                              ├─ Define: Tipo (mTipoTicket)
                              └─ Status inicial (mStatusTicket)
```

### 2. Asignación
```
mTickets → Se asigna técnico → dTicketsTecnicos
                                    │
                                    └─ mEmpleados (técnico)
```

### 3. Trabajo en el Ticket
```
Técnico → Registra eventos → dTickets
                                  │
                                  ├─ Evento (descripción)
                                  ├─ Tiempo (minutos)
                                  ├─ Fecha
                                  └─ Usuario (técnico)
```

### 4. Cierre y Valoración
```
mTickets (cerrado) → Mueve a → hTickets
                                   │
dTicketsTecnicos → Mueve a → hdTicketsTecnicos
                                   │
dTickets → Mueve a → hdTickets
                                   │
                              mValoracionTicket
                                   │
                                   ├─ Valoracion (1-5)
                                   └─ Comentario
```

## Cardinalidades

| Relación | De | A | Tipo |
|----------|-----|---|------|
| Usuario-Tickets | mPerEmp | mTickets | 1:N |
| Ticket-Técnicos | mTickets | dTicketsTecnicos | 1:N |
| Técnico-Asignaciones | mEmpleados | dTicketsTecnicos | 1:N |
| Ticket-Eventos | mTickets | dTickets | 1:N |
| Ticket-Valoración | mTickets | mValoracionTicket | 1:1 |
| Departamento-Categorías | mDepartamentos | mCategoriasTicket | 1:N |
| Categoría-SubCategorías | mCategoriasTicket | mSubCategoriasTicket | 1:N |
| SubCategoría-Tickets | mSubCategoriasTicket | mTickets | 1:N |
| Status-Tickets | mStatusTicket | mTickets | 1:N |
| Prioridad-Tickets | mPrioridadTicket | mTickets | 1:N |
| TipoTicket-Tickets | mTipoTicket | mTickets | 1:N |
| Departamento-Puestos | mDepartamentos | mPuestos | 1:N |
| Puesto-Empleados | mPuestos | dEmpleados | 1:N |

## Índices y Claves

### Claves Primarias
- **mPerEmp**: IdPersona (Identity)
- **mEmpleados**: IdPersona
- **mDepartamentos**: IdDepto (Identity)
- **mPuestos**: IdPuesto (Identity)
- **mStatusTicket**: Status (Identity)
- **mPrioridadTicket**: IdPrioridad (Identity)
- **mTipoTicket**: IdTipoTicket (Identity)
- **mCategoriasTicket**: IdCategoria (Identity)
- **mSubCategoriasTicket**: IdSubCategoria (Identity)
- **mTickets**: IdTicket (Identity)
- **dTickets**: IdDTicket (Identity)
- **dTicketsTecnicos**: (IdTicket, IdPersona) - Compuesta
- **hTickets**: IdTicket
- **hdTickets**: IdDTicket
- **hdTicketsTecnicos**: Sin PK definida

### Claves Foráneas Principales
- **mTickets.Usuario** → mPerEmp.IdPersona
- **mTickets.IdSubCategoria** → mSubCategoriasTicket.IdSubCategoria
- **mTickets.Status** → mStatusTicket.Status
- **mTickets.Prioridad** → mPrioridadTicket.IdPrioridad
- **mTickets.IdTipoTicket** → mTipoTicket.IdTipoTicket
- **dTickets.IdTicket** → mTickets.IdTicket
- **dTicketsTecnicos.IdTicket** → mTickets.IdTicket
- **dTicketsTecnicos.IdPersona** → mEmpleados.IdPersona

## Reglas de Negocio

1. **Creación de Ticket**
   - Debe tener un usuario solicitante (Usuario → mPerEmp)
   - Debe tener una subcategoría (IdSubCategoria)
   - Debe tener un título y descripción
   - Debe tener un status inicial
   - FeAlta se registra automáticamente

2. **Asignación de Técnico**
   - Se registra en dTicketsTecnicos
   - Un ticket puede tener múltiples técnicos
   - FeAsignacion se actualiza en mTickets

3. **Registro de Eventos**
   - Cada acción se registra en dTickets
   - Se registra el tiempo invertido
   - Se registra el usuario que realizó la acción

4. **Cierre de Ticket**
   - Se actualiza FeCierre en mTickets
   - Se mueve el ticket a hTickets
   - Se mueven los técnicos a hdTicketsTecnicos
   - Se mueven los eventos a hdTickets
   - Se puede solicitar valoración (mValoracionTicket)

5. **Categorización**
   - Departamento → Categoría → SubCategoría
   - Cada nivel es obligatorio
   - La jerarquía define el flujo de trabajo

6. **Prioridades y Tipos**
   - Son catálogos configurables
   - Permiten clasificar y ordenar tickets
   - Pueden ser NULL en algunos casos

## Campos de Auditoría

### Fechas
- **FeAlta**: Fecha de alta (creación) - Obligatorio
- **FeAsignacion**: Fecha de asignación a técnico - Opcional
- **FeCompromiso**: Fecha compromiso de resolución - Opcional
- **FeCierre**: Fecha de cierre - Opcional

### Usuarios
- **Usuario** (en mTickets): Solicitante del ticket
- **Usuario** (en dTickets): Técnico que registra el evento

## Consideraciones de Performance

1. **Índices Recomendados** (no incluidos en el script):
   - mTickets.Usuario
   - mTickets.Status
   - mTickets.FeAlta
   - dTickets.IdTicket
   - dTicketsTecnicos.IdPersona

2. **Particionamiento** (para producción):
   - Considerar particionar hTickets por año
   - Considerar particionar hdTickets por año

3. **Archivado**:
   - Las tablas históricas pueden crecer considerablemente
   - Implementar política de archivado para registros antiguos

## Integridad Referencial

Todas las foreign keys están configuradas con:
- **ON DELETE**: No especificado (comportamiento por defecto: NO ACTION)
- **ON UPDATE**: No especificado (comportamiento por defecto: NO ACTION)

Esto significa que:
- No se pueden eliminar registros padre si tienen hijos
- Los cambios en claves primarias no se propagan automáticamente

---

**Nota**: Este diagrama representa el esquema lógico del sistema de tickets. Para el esquema físico completo, consultar el archivo `Tickets_Isolated_Script.sql`.

