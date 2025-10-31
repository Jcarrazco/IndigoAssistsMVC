using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IndigoAssits.Core.Dtos
{
    public class TicketCreateDto
    {
        [Required(ErrorMessage = "El usuario solicitante es requerido")]
        public int UsuarioSolicitante { get; set; }

        [Required(ErrorMessage = "La subcategoría es requerida")]
        public byte IdSubCategoria { get; set; }

        [Required(ErrorMessage = "El título es requerido")]
        [StringLength(50, ErrorMessage = "El título no puede exceder 50 caracteres")]
        public string Titulo { get; set; } = string.Empty;

        [Required(ErrorMessage = "La descripción es requerida")]
        [StringLength(2000, ErrorMessage = "La descripción no puede exceder 2000 caracteres")]
        public string Descripcion { get; set; } = string.Empty;

        public byte IdTipoTicket { get; set; }

        public byte Prioridad { get; set; }
    }

    public class TicketUpdateDto
    {
        [Required(ErrorMessage = "El ID del ticket es requerido")]
        public int IdTicket { get; set; }

        [StringLength(50, ErrorMessage = "El título no puede exceder 50 caracteres")]
        public string? Titulo { get; set; }

        [StringLength(2000, ErrorMessage = "La descripción no puede exceder 2000 caracteres")]
        public string? Descripcion { get; set; }

        public byte? Status { get; set; }

        public byte? IdTipoTicket { get; set; }

        public byte? Prioridad { get; set; }

        public byte? IdSubCategoria { get; set; }

        public DateTime? FeAsignacion { get; set; }

        public DateTime? FeCompromiso { get; set; }

        public DateTime? FeCierre { get; set; }
    }

    public class TicketAsignacionDto
    {
        [Required(ErrorMessage = "El ID del ticket es requerido")]
        public int IdTicket { get; set; }

        [Required(ErrorMessage = "El ID del técnico es requerido")]
        public int IdTecnico { get; set; }

        public DateTime FeCompromiso { get; set; }
    }

    public class TicketResponseDto
    {
        public int IdTicket { get; set; }
        public int UsuarioSolicitante { get; set; }
        public string SolicitanteNombre { get; set; } = string.Empty;
        public byte IdSubCategoria { get; set; }
        public string SubCategoriaNombre { get; set; } = string.Empty;
        public byte IdCategoria { get; set; }
        public string CategoriaNombre { get; set; } = string.Empty;
        public string Titulo { get; set; } = string.Empty;
        public string Descripcion { get; set; } = string.Empty;
        public byte Status { get; set; }
        public string StatusDescripcion { get; set; } = string.Empty;
        public byte IdTipoTicket { get; set; }
        public string TipoTicketNombre { get; set; }
        public byte Prioridad { get; set; }
        public string PrioridadNombre { get; set; }
        public DateTime FeAlta { get; set; }
        public DateTime FeAsignacion { get; set; }
        public DateTime FeCompromiso { get; set; }
        public DateTime FeCierre { get; set; }
        public int IdTecnico { get; set; }
        public string TecnicoNombre { get; set; }
        public byte IdDepartamento { get; set; }
        public string DepartamentoNombre { get; set; } = string.Empty;
    }

    public class TicketFiltroDto
    {
        public int UsuarioSolicitante { get; set; }
        public int IdTecnico { get; set; }
        public byte Status { get; set; }
        public byte IdCategoria { get; set; }
        public byte IdSubCategoria { get; set; }
        public byte Prioridad { get; set; }
        public byte IdTipoTicket { get; set; }
        public byte IdDepartamento { get; set; }
        public DateTime FechaInicio { get; set; }
        public DateTime FechaFin { get; set; }
        public string BusquedaTexto { get; set; }
        public int Pagina { get; set; } = 1;
        public int TamañoPagina { get; set; } = 10;
    }

    public class TicketEstadisticasDto
    {
        public int TotalAbiertos { get; set; }
        public int TotalEnProceso { get; set; }
        public int TotalAsignados { get; set; }
        public int TotalCerrados { get; set; }
        public Dictionary<string, int> PorDepartamento { get; set; } = new Dictionary<string, int>();
        public Dictionary<string, int> PorPrioridad { get; set; } = new Dictionary<string, int>();
        public Dictionary<string, int> PorEstado { get; set; } = new Dictionary<string, int>();
    }

    public class TicketPaginadoDto
    {
        public List<TicketResponseDto> Tickets { get; set; } = new List<TicketResponseDto>();
        public int TotalRegistros { get; set; }
        public int PaginaActual { get; set; }
        public int TotalPaginas { get; set; }
        public int TamañoPagina { get; set; }
    }
}
