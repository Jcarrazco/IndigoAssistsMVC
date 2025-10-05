# Script Aislado del Sistema de Tickets - Indigo

## Descripción
Este repositorio contiene el script SQL aislado del sistema de tickets extraído de la base de datos de producción Indigo. El objetivo es proporcionar un entorno de pruebas limpio sin datos de producción.

## Archivos Generados
- `Tickets_Isolated_Script.sql` - Script SQL completo con todas las estructuras del sistema de tickets

## Estructuras Incluidas

### Tablas Base (3)
1. **mPersonas** - Personas físicas y morales
   - Persona (PK, Identity)
   - Nombre, Paterno, Materno
   - Descripcion
   - RFC, Email
   - TipoPersona (F/M)
   - IdRegimenFiscal, IdUsoCFDI
   - IdReferencia (auto-referencia)
   - Usuario, FeModifica

2. **mEmpresas** - Empresas del sistema
   - IdEmpresa (PK, Identity)
   - Persona (FK a mPersonas)
   - Logo (image)

3. **mSysVar** - Variables del sistema
   - Variable (PK)
   - Valor

### Tablas Maestras (Catálogos)
4. **mPerEmp** - Relación Persona-Empresa
   - IdPersona (PK, Identity)
   - IdEmpresa
   - Persona

5. **mEmpleados** - Empleados del sistema
   - IdPersona (PK)
   - Login
   - Activo

6. **mDepartamentos** - Departamentos de la empresa
   - IdDepto (PK, Identity)
   - Departamento
   - Tickets (bit)

7. **mPuestos** - Puestos de trabajo
   - IdPuesto (PK, Identity)
   - Puesto
   - IdDepto (FK)

8. **mStatusTicket** - Estados de los tickets
   - Status (PK, Identity)
   - StatusDes

9. **mPrioridadTicket** - Prioridades de tickets
   - IdPrioridad (PK, Identity)
   - Prioridad

10. **mTipoTicket** - Tipos de tickets
    - IdTipoTicket (PK, Identity)
    - TipoTicket

11. **mCategoriasTicket** - Categorías de tickets
    - IdCategoria (PK, Identity)
    - Categoria
    - IdDepto (FK)

12. **mSubCategoriasTicket** - Subcategorías de tickets
    - IdSubCategoria (PK, Identity)
    - SubCategoria
    - IdCategoria (FK)

### Tabla Principal
13. **mTickets** - Tabla principal de tickets
    - IdTicket (PK, Identity)
    - Usuario (FK a mPerEmp)
    - IdSubCategoria (FK)
    - Titulo
    - Descripcion
    - Status (FK)
    - IdTipoTicket (FK)
    - Prioridad (FK)
    - FeAlta
    - FeAsignacion
    - FeCompromiso
    - FeCierre

### Tablas de Detalle
14. **dEmpleados** - Detalle de empleados y puestos
    - IdPersona
    - IdPuesto (FK)
    - Principal

15. **dTickets** - Log de eventos de tickets
    - IdDTicket (PK, Identity)
    - IdTicket (FK)
    - Evento
    - Tiempo
    - Fecha
    - Usuario

16. **dTicketsTecnicos** - Asignación de técnicos a tickets
    - IdTicket (PK, FK)
    - IdPersona (PK, FK)

17. **mValoracionTicket** - Valoración de tickets cerrados
    - IdTicket
    - Fecha
    - Valoracion
    - Comentario

### Tablas Históricas
18. **hTickets** - Histórico de tickets cerrados
    - IdTicket (PK)
    - Usuario (FK)
    - IdSubCategoria (FK)
    - Titulo
    - Descripcion
    - IdTipoTicket (FK)
    - Prioridad (FK)
    - FeAlta
    - FeAsignacion
    - FeCompromiso
    - FeCierre

19. **hdTickets** - Histórico de eventos de tickets cerrados
    - IdDTicket (PK)
    - IdTicket (FK)
    - Evento
    - Tiempo
    - Fecha
    - Usuario

20. **hdTicketsTecnicos** - Histórico de asignación de técnicos
    - IdTicket (FK)
    - IdPersona (FK)

## Vistas Incluidas

1. **vNombres** - Vista básica de nombres de personas
   - Información esencial: IdPersona, IdEmpresa, Nombre completo, Descripción, RFC, Email, TipoPersona
   - Formato de nombre: Nombre + Paterno + Materno

2. **vPersonas** - Vista completa de personas con información de empresa
   - Incluye información de empresa y logo
   - Formato de nombre: Paterno + Materno + Nombre
   - Campos adicionales: Logo de empresa

3. **vEmpleados** - Vista consolidada de empleados
   - Muestra empleados con sus puestos, departamentos y acceso a tickets

4. **vTickets** - Vista principal de tickets activos
   - Consolidación completa de tickets con información del solicitante, técnico asignado, categorías, status, etc.

5. **vhTickets** - Vista de tickets históricos (cerrados)
   - Similar a vTickets pero para tickets en el histórico

## Funciones

1. **GetSysVar** (@variable NVARCHAR(20))
   - Obtiene el valor de una variable del sistema desde mSysVar
   - Parámetros:
     - @variable: Nombre de la variable a consultar
   - Retorna: Valor de la variable (NVARCHAR(50))

2. **GetAnotacionesTecnicosTicket** (@Historico BIT, @IdTicket INT)
   - Regresa las anotaciones de los técnicos que atendieron el ticket
   - Parámetros:
     - @Historico: 0 para tickets activos, 1 para históricos
     - @IdTicket: ID del ticket a consultar
   - Retorna: Tabla con eventos, tiempos, fechas y usuarios

## Stored Procedures

1. **TicketValoracionEnviar** (@idticket INT)
   - Valida si se puede enviar encuesta de valoración
   - Verifica que no se excedan las encuestas por día
   - Retorna: 1 si se puede enviar, 0 si no

## Relaciones (Foreign Keys)

### Jerarquía de Catálogos
```
mDepartamentos
    └── mPuestos (IdDepto)
        └── dEmpleados (IdPuesto)
    └── mCategoriasTicket (IdDepto)
        └── mSubCategoriasTicket (IdCategoria)
```

### Relaciones del Ticket
```
mPerEmp (Usuario)
    └── mTickets
        ├── mStatusTicket (Status)
        ├── mPrioridadTicket (Prioridad)
        ├── mTipoTicket (IdTipoTicket)
        ├── mSubCategoriasTicket (IdSubCategoria)
        ├── dTickets (IdTicket) - Log de eventos
        ├── dTicketsTecnicos (IdTicket) - Técnicos asignados
        └── mValoracionTicket (IdTicket) - Valoración
```

### Relaciones Históricas
```
mPerEmp (Usuario)
    └── hTickets
        ├── mPrioridadTicket (Prioridad)
        ├── mTipoTicket (IdTipoTicket)
        ├── mSubCategoriasTicket (IdSubCategoria)
        ├── hdTickets (IdTicket) - Log histórico
        └── hdTicketsTecnicos (IdTicket) - Técnicos históricos
```

### Relaciones de Empleados
```
mEmpleados (IdPersona)
    ├── dTicketsTecnicos (IdPersona)
    └── hdTicketsTecnicos (IdPersona)
```

## Datos de Prueba Incluidos (Seeders)

El script incluye datos de prueba completos para un entorno funcional:

### Usuarios del Sistema
- **ADMIN** - Juan Carlos García López (Administrador del Sistema)
- **MARIA.R** - María Elena Rodríguez Martínez (Gerente de TI)
- **CARLOS.H** - Carlos Alberto Hernández González (Técnico Senior)
- **ANA.S** - Ana Patricia Sánchez Flores (Técnico Junior)
- **ROBERTO.J** - Roberto Jiménez Vega (Usuario Final)

### Estructura Organizacional
- **5 Departamentos**: Sistemas, Recursos Humanos, Contabilidad, Ventas, Almacén
- **11 Puestos**: Desde Gerentes hasta Operadores
- **1 Empresa**: Empresa Demo S.A. de C.V.

### Catálogos de Tickets
- **4 Estados**: Nuevo, En Proceso, Cerrado, Cancelado
- **4 Prioridades**: Baja, Media, Alta, Crítica
- **4 Tipos**: Incidente, Solicitud, Problema, Cambio
- **10 Categorías**: Hardware, Software, Redes, Usuarios, RH, Nómina, Contabilidad, Facturación, Ventas, CRM
- **30 Subcategorías**: Desde Equipos de Cómputo hasta Integración CRM

### Tickets de Prueba
- **5 Tickets Activos**: Con diferentes estados, prioridades y técnicos asignados
- **2 Tickets Históricos**: Cerrados con valoraciones de usuarios
- **Eventos Completos**: Log de actividades en todos los tickets
- **Asignaciones**: Técnicos asignados a tickets específicos

### Variables del Sistema
- **TicketNoEncuestas**: '2' (máximo de encuestas por día)
- **TicketTiempoMaximo**: '480' (tiempo máximo en minutos)
- **TicketNotificacionEmail**: '1' (notificaciones habilitadas)
- **TicketAutoAsignacion**: '0' (auto-asignación deshabilitada)

## Dependencias Incluidas

El script ahora incluye todas las dependencias necesarias:

1. **mPersonas** - Tabla base de personas (física/moral)
2. **mEmpresas** - Tabla de empresas (relacionada con mPersonas)
3. **mSysVar** - Variables del sistema
4. **GetSysVar()** - Función para obtener variables del sistema

**Nota**: El script es completamente autocontenido y no requiere dependencias externas adicionales.

## Orden de Ejecución Recomendado

El script está ordenado correctamente para su ejecución secuencial:

1. **Funciones** - GetSysVar, GetAnotacionesTecnicosTicket
2. **Tablas base** - mPersonas, mEmpresas, mSysVar
3. **Tablas maestras** - mPerEmp, mEmpleados, mDepartamentos, mPuestos, etc.
4. **Tabla principal** - mTickets
5. **Tablas de detalle** - dEmpleados, dTickets, dTicketsTecnicos, mValoracionTicket
6. **Tablas históricas** - hTickets, hdTickets, hdTicketsTecnicos
7. **Vistas** - vEmpleados, vTickets, vhTickets
8. **Defaults y Constraints**
9. **Foreign Keys**
10. **Stored Procedures**

**Nota**: El script ya está ordenado correctamente y puede ejecutarse directamente sin modificaciones.

## Notas Importantes

1. **Sin Datos de Producción**: Este script solo contiene las estructuras (DDL), no incluye datos (DML)

2. **Tablas Históricas**: El sistema mantiene un histórico de tickets cerrados en tablas separadas (hTickets, hdTickets, hdTicketsTecnicos)

3. **Log de Eventos**: La tabla dTickets registra todos los eventos y acciones realizadas en cada ticket

4. **Valoración**: El sistema permite valorar tickets a través de mValoracionTicket

5. **Multi-técnico**: Un ticket puede ser asignado a múltiples técnicos (tabla dTicketsTecnicos)

6. **Departamentos**: Los departamentos tienen un flag 'Tickets' que indica si manejan tickets

7. **Categorización**: Sistema de 3 niveles: Departamento > Categoría > SubCategoría

## Flujo del Sistema de Tickets

```
1. Usuario crea ticket (mTickets)
   └── Se asigna categoría (mSubCategoriasTicket)
   └── Se define prioridad (mPrioridadTicket)
   └── Se define tipo (mTipoTicket)
   
2. Se asignan técnicos (dTicketsTecnicos)
   
3. Técnicos registran eventos (dTickets)
   └── Tiempo invertido
   └── Descripción del evento
   
4. Ticket se cierra
   └── Se actualiza fecha de cierre
   └── Se mueve a histórico (hTickets)
   └── Se envía valoración (mValoracionTicket)
```

## Campos Importantes de Fechas

- **FeAlta**: Fecha de creación del ticket
- **FeAsignacion**: Fecha de asignación a técnico
- **FeCompromiso**: Fecha compromiso de resolución
- **FeCierre**: Fecha de cierre del ticket

## Soporte

Para preguntas o problemas con este script, contactar al equipo de desarrollo.

---

**Fecha de Extracción**: 04/10/2025  
**Base de Datos Origen**: Indigo (Producción)  
**Versión**: 3.0 (Completo con Seeders - Listo para usar)

## Próximos Pasos Recomendados

1. **Ejecutar el script** directamente en tu entorno de pruebas
2. **Probar las funcionalidades** con los datos de prueba incluidos
3. **Personalizar los datos** según tu organización:
   - Modificar departamentos y puestos
   - Agregar más usuarios
   - Configurar categorías específicas
4. **Configurar variables adicionales** en mSysVar según tus necesidades
5. **Crear más tickets de prueba** para probar diferentes escenarios

El script incluye datos de prueba completos y está listo para usar inmediatamente.

