using IndigoAssits.Core.Dtos;

namespace IndigoAssitsReglasDeNegocio.Interfaces
{
    public interface ITicketService
    {
        Task<TicketPaginadoDto> GetTicketsPaginadosAsync(TicketFiltroDto filtros);
        Task<IEnumerable<TicketResponseDto>> GetTicketsAsync(TicketFiltroDto filtros);
        Task<TicketResponseDto?> GetTicketPorIdAsync(int idTicket);
        Task<int> CrearTicketAsync(TicketCreateDto dto);
        Task<bool> ActualizarTicketAsync(TicketUpdateDto dto);
        Task<bool> AsignarTicketAsync(TicketAsignacionDto dto);
        Task<bool> DesasignarTicketAsync(int idTicket);
        Task<bool> CambiarEstadoTicketAsync(int idTicket, byte nuevoEstado);
        Task<TicketEstadisticasDto> GetEstadisticasAsync(byte? idDepartamento = null);
        Task<IEnumerable<TicketResponseDto>> GetTicketsRecientesAsync(int cantidad = 10);
        Task<IEnumerable<TicketResponseDto>> BuscarTicketsAsync(string terminoBusqueda);
    }
}

