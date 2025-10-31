using IndigoAssits.Core.Dtos;
using IndigoAssitsReglasDeNegocio.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IndigoAssits.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class TicketsController : ControllerBase
    {
        private readonly ITicketService _ticketService;

        public TicketsController(ITicketService ticketService)
        {
            _ticketService = ticketService;
        }

        [HttpGet]
        public async Task<ActionResult<TicketPaginadoDto>> Get([FromQuery] TicketFiltroDto filtros)
        {
            var result = await _ticketService.GetTicketsPaginadosAsync(filtros);
            return Ok(result);
        }

        [HttpGet("{id:int}")]
        public async Task<ActionResult<TicketResponseDto>> GetById(int id)
        {
            var result = await _ticketService.GetTicketPorIdAsync(id);
            if (result == null) return NotFound();
            return Ok(result);
        }

        [HttpPost]
        public async Task<ActionResult<int>> Create([FromBody] TicketCreateDto dto)
        {
            var id = await _ticketService.CrearTicketAsync(dto);
            return CreatedAtAction(nameof(GetById), new { id }, id);
        }

        [HttpPut("{id:int}")]
        public async Task<IActionResult> Update(int id, [FromBody] TicketUpdateDto dto)
        {
            if (id != dto.IdTicket) return BadRequest("Id inconsistente");
            var ok = await _ticketService.ActualizarTicketAsync(dto);
            if (!ok) return NotFound();
            return NoContent();
        }

        [HttpPatch("{id:int}/asignar")]
        public async Task<IActionResult> Asignar(int id, [FromBody] TicketAsignacionDto dto)
        {
            if (id != dto.IdTicket) return BadRequest("Id inconsistente");
            var ok = await _ticketService.AsignarTicketAsync(dto);
            if (!ok) return NotFound();
            return NoContent();
        }

        [HttpPatch("{id:int}/desasignar")]
        public async Task<IActionResult> Desasignar(int id)
        {
            var ok = await _ticketService.DesasignarTicketAsync(id);
            if (!ok) return NotFound();
            return NoContent();
        }

        [HttpPatch("{id:int}/estado/{estado:int}")]
        public async Task<IActionResult> CambiarEstado(int id, int estado)
        {
            if (estado < 0 || estado > 255) return BadRequest("El valor del estado debe estar entre 0 y 255");
            var ok = await _ticketService.CambiarEstadoTicketAsync(id, (byte)estado);
            if (!ok) return NotFound();
            return NoContent();
        }

        [HttpGet("dashboard")]
        public async Task<ActionResult<TicketEstadisticasDto>> Dashboard([FromQuery] byte? idDepartamento)
        {
            var result = await _ticketService.GetEstadisticasAsync(idDepartamento);
            return Ok(result);
        }

        [HttpGet("buscar")]
        public async Task<ActionResult<IEnumerable<TicketResponseDto>>> Buscar([FromQuery] string q)
        {
            var result = await _ticketService.BuscarTicketsAsync(q ?? string.Empty);
            return Ok(result);
        }
    }
}
