using Microsoft.EntityFrameworkCore;
using IndigoAssits.Repositorio.Core.Entities;
using IndigoAssits.Repositorio.Core.Interfaces;
using IndigoAsists.Repositorio.Db;

namespace IndigoAsists.Repositorio.Repositories
{
    /// <summary>
    /// Implementación del repositorio de tickets
    /// </summary>
    public class TicketRepository : GenericRepository<Ticket>, ITicketRepository
    {
        public TicketRepository(IndigoDbContext context) : base(context)
        {
        }

        public async Task<IEnumerable<TicketVista>> GetTicketsVistaAsync()
        {
            return await _context.TicketVistas.ToListAsync();
        }

        public async Task<IEnumerable<TicketVista>> GetTicketsByUsuarioAsync(int usuarioId)
        {
            return await _context.TicketVistas
                .Where(t => t.IdSolicitante == usuarioId)
                .ToListAsync();
        }

        public async Task<IEnumerable<TicketVista>> GetTicketsByTecnicoAsync(int tecnicoId)
        {
            return await _context.TicketVistas
                .Where(t => t.IdTecnico == tecnicoId)
                .ToListAsync();
        }

        public async Task<IEnumerable<TicketVista>> GetTicketsByEstadoAsync(byte estado)
        {
            return await _context.TicketVistas
                .Where(t => t.Status == estado)
                .ToListAsync();
        }

        public async Task<IEnumerable<TicketVista>> GetTicketsByPrioridadAsync(byte prioridad)
        {
            return await _context.TicketVistas
                .Where(t => t.IdPrioridad == prioridad)
                .ToListAsync();
        }

        public async Task<IEnumerable<TicketVista>> GetTicketsByCategoriaAsync(byte categoriaId)
        {
            return await _context.TicketVistas
                .Where(t => t.IdCategoria == categoriaId)
                .ToListAsync();
        }

        public async Task<IEnumerable<TicketVista>> GetTicketsByDepartamentoAsync(byte departamentoId)
        {
            return await _context.TicketVistas
                .Where(t => t.IdDepto == departamentoId)
                .ToListAsync();
        }

        public async Task<IEnumerable<TicketVista>> GetTicketsByFechaAsync(DateTime fechaInicio, DateTime fechaFin)
        {
            return await _context.TicketVistas
                .Where(t => t.FeAlta >= fechaInicio && t.FeAlta <= fechaFin)
                .ToListAsync();
        }

        public async Task<IEnumerable<TicketVista>> GetTicketsWithFiltersAsync(
            int? usuarioId = null,
            int? tecnicoId = null,
            byte? estado = null,
            byte? prioridad = null,
            byte? categoriaId = null,
            byte? departamentoId = null,
            DateTime? fechaInicio = null,
            DateTime? fechaFin = null,
            string? busquedaTexto = null)
        {
            var query = _context.TicketVistas.AsQueryable();

            if (usuarioId.HasValue)
                query = query.Where(t => t.IdSolicitante == usuarioId.Value);

            if (tecnicoId.HasValue)
                query = query.Where(t => t.IdTecnico == tecnicoId.Value);

            if (estado.HasValue)
                query = query.Where(t => t.Status == estado.Value);

            if (prioridad.HasValue)
                query = query.Where(t => t.IdPrioridad == prioridad.Value);

            if (categoriaId.HasValue)
                query = query.Where(t => t.IdCategoria == categoriaId.Value);

            if (departamentoId.HasValue)
                query = query.Where(t => t.IdDepto == departamentoId.Value);

            if (fechaInicio.HasValue)
                query = query.Where(t => t.FeAlta >= fechaInicio.Value);

            if (fechaFin.HasValue)
                query = query.Where(t => t.FeAlta <= fechaFin.Value);

            if (!string.IsNullOrEmpty(busquedaTexto))
            {
                query = query.Where(t => t.Titulo.Contains(busquedaTexto) ||
                                       t.Descripcion.Contains(busquedaTexto) ||
                                       t.Solicitante.Contains(busquedaTexto) ||
                                       t.Tecnico.Contains(busquedaTexto));
            }

            return await query.ToListAsync();
        }

        public async Task<(IEnumerable<TicketVista> Items, int TotalCount)> GetTicketsPagedAsync(
            int page,
            int pageSize,
            int? usuarioId = null,
            int? tecnicoId = null,
            byte? estado = null,
            byte? prioridad = null,
            byte? categoriaId = null,
            byte? departamentoId = null,
            DateTime? fechaInicio = null,
            DateTime? fechaFin = null,
            string? busquedaTexto = null)
        {
            var query = _context.TicketVistas.AsQueryable();

            // Aplicar filtros
            if (usuarioId.HasValue)
                query = query.Where(t => t.IdSolicitante == usuarioId.Value);

            if (tecnicoId.HasValue)
                query = query.Where(t => t.IdTecnico == tecnicoId.Value);

            if (estado.HasValue)
                query = query.Where(t => t.Status == estado.Value);

            if (prioridad.HasValue)
                query = query.Where(t => t.IdPrioridad == prioridad.Value);

            if (categoriaId.HasValue)
                query = query.Where(t => t.IdCategoria == categoriaId.Value);

            if (departamentoId.HasValue)
                query = query.Where(t => t.IdDepto == departamentoId.Value);

            if (fechaInicio.HasValue)
                query = query.Where(t => t.FeAlta >= fechaInicio.Value);

            if (fechaFin.HasValue)
                query = query.Where(t => t.FeAlta <= fechaFin.Value);

            if (!string.IsNullOrEmpty(busquedaTexto))
            {
                query = query.Where(t => t.Titulo.Contains(busquedaTexto) ||
                                       t.Descripcion.Contains(busquedaTexto) ||
                                       t.Solicitante.Contains(busquedaTexto) ||
                                       t.Tecnico.Contains(busquedaTexto));
            }

            var totalCount = await query.CountAsync();
            var items = await query
                .OrderByDescending(t => t.FeAlta)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            return (items, totalCount);
        }

        public async Task<bool> AsignarTicketAsync(int ticketId, int tecnicoId, DateTime? fechaCompromiso = null)
        {
            var ticket = await _dbSet.FindAsync(ticketId);
            if (ticket == null) return false;

            ticket.FeAsignacion = DateTime.Now;
            if (fechaCompromiso.HasValue)
                ticket.FeCompromiso = fechaCompromiso.Value;

            // Agregar relación técnico-ticket
            var ticketTecnico = new dTicketsTecnicos
            {
                IdTicket = ticketId,
                IdPersona = tecnicoId
            };

            _context.TicketsTecnicos.Add(ticketTecnico);
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<bool> DesasignarTicketAsync(int ticketId)
        {
            var ticket = await _dbSet.FindAsync(ticketId);
            if (ticket == null) return false;

            ticket.FeAsignacion = null;
            ticket.FeCompromiso = null;

            // Remover relaciones técnico-ticket
            var ticketsTecnicos = await _context.TicketsTecnicos
                .Where(tt => tt.IdTicket == ticketId)
                .ToListAsync();

            _context.TicketsTecnicos.RemoveRange(ticketsTecnicos);
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<bool> CambiarEstadoTicketAsync(int ticketId, byte nuevoEstado)
        {
            var ticket = await _dbSet.FindAsync(ticketId);
            if (ticket == null) return false;

            ticket.Status = nuevoEstado;

            // Si se cierra el ticket, establecer fecha de cierre
            if (nuevoEstado == 3) // Asumiendo que 3 es "Cerrado"
            {
                ticket.FeCierre = DateTime.Now;
            }

            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<Dictionary<string, int>> GetEstadisticasPorEstadoAsync()
        {
            return await _context.TicketVistas
                .GroupBy(t => t.StatusDes)
                .ToDictionaryAsync(g => g.Key, g => g.Count());
        }

        public async Task<Dictionary<string, int>> GetEstadisticasPorPrioridadAsync()
        {
            return await _context.TicketVistas
                .GroupBy(t => t.IdPrioridad.ToString())
                .ToDictionaryAsync(g => g.Key, g => g.Count());
        }

        public async Task<Dictionary<string, int>> GetEstadisticasPorDepartamentoAsync()
        {
            return await _context.TicketVistas
                .GroupBy(t => t.Departamento)
                .ToDictionaryAsync(g => g.Key, g => g.Count());
        }

        public async Task<Dictionary<string, int>> GetEstadisticasPorTecnicoAsync()
        {
            return await _context.TicketVistas
                .Where(t => !string.IsNullOrEmpty(t.Tecnico))
                .GroupBy(t => t.Tecnico)
                .ToDictionaryAsync(g => g.Key, g => g.Count());
        }

        public async Task<int> GetTotalTicketsAbiertosByDepartamentoAsync(byte departamentoId)
        {
            return await _context.TicketVistas
                .CountAsync(t => t.IdDepto == departamentoId && t.Status == 1); // Asumiendo que 1 es "Abierto"
        }

        public async Task<int> GetTotalTicketsEnProcesoByDepartamentoAsync(byte departamentoId)
        {
            return await _context.TicketVistas
                .CountAsync(t => t.IdDepto == departamentoId && t.Status == 2); // Asumiendo que 2 es "En Proceso"
        }

        public async Task<int> GetTotalTicketsCerradosByDepartamentoAsync(byte departamentoId)
        {
            return await _context.TicketVistas
                .CountAsync(t => t.IdDepto == departamentoId && t.Status == 3); // Asumiendo que 3 es "Cerrado"
        }

        public async Task<TicketDashboardViewModel> GetDashboardDataAsync(int? usuarioId = null)
        {
            var dashboard = new TicketDashboardViewModel();

            // Obtener estadísticas generales
            dashboard.Estadisticas.TotalAbiertos = await _context.TicketVistas.CountAsync(t => t.Status == 1);
            dashboard.Estadisticas.TotalEnProceso = await _context.TicketVistas.CountAsync(t => t.Status == 2);
            dashboard.Estadisticas.TotalCerrados = await _context.TicketVistas.CountAsync(t => t.Status == 3);

            // Obtener estadísticas por departamento
            dashboard.Estadisticas.PorDepartamento = await _context.TicketVistas
                .GroupBy(t => t.Departamento)
                .ToDictionaryAsync(g => g.Key, g => g.Count());

            // Obtener estadísticas por prioridad
            dashboard.Estadisticas.PorPrioridad = await _context.TicketVistas
                .GroupBy(t => t.IdPrioridad.ToString())
                .ToDictionaryAsync(g => g.Key, g => g.Count());

            // Obtener tickets recientes
            dashboard.TicketsAbiertosDepto = await _context.TicketVistas
                .Where(t => t.Status == 1)
                .OrderByDescending(t => t.FeAlta)
                .Take(10)
                .ToListAsync();

            return dashboard;
        }

        public async Task<IEnumerable<TicketVista>> GetTicketsRecientesAsync(int cantidad = 10)
        {
            return await _context.TicketVistas
                .OrderByDescending(t => t.FeAlta)
                .Take(cantidad)
                .ToListAsync();
        }

        public async Task<IEnumerable<TicketVista>> GetTicketsVencidosAsync()
        {
            var hoy = DateTime.Now.Date;
            return await _context.TicketVistas
                .Where(t => t.FeCompromiso.HasValue && t.FeCompromiso.Value.Date < hoy && t.Status != 3)
                .ToListAsync();
        }

        public async Task<IEnumerable<TicketVista>> GetTicketsPorVencerAsync(int diasAntes = 3)
        {
            var fechaLimite = DateTime.Now.Date.AddDays(diasAntes);
            return await _context.TicketVistas
                .Where(t => t.FeCompromiso.HasValue && 
                           t.FeCompromiso.Value.Date <= fechaLimite && 
                           t.FeCompromiso.Value.Date >= DateTime.Now.Date &&
                           t.Status != 3)
                .ToListAsync();
        }

        public async Task<IEnumerable<TicketVista>> BuscarTicketsAsync(string terminoBusqueda)
        {
            if (string.IsNullOrEmpty(terminoBusqueda))
                return new List<TicketVista>();

            return await _context.TicketVistas
                .Where(t => t.Titulo.Contains(terminoBusqueda) ||
                           t.Descripcion.Contains(terminoBusqueda) ||
                           t.Solicitante.Contains(terminoBusqueda) ||
                           t.Tecnico.Contains(terminoBusqueda))
                .ToListAsync();
        }
    }
}
