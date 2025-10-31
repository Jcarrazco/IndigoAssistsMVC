using IndigoAssits.Core.Dtos;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace IndigoAssits.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class InicioDeSessionesController : ControllerBase
    {
        [HttpGet]
        public IActionResult GetToken()
        {
            InicioDeSessionDto inicioDeSession = new InicioDeSessionDto
            {
                Usuario = "testuser",
                Password = "testpassword"
            };

            return Ok(inicioDeSession);
        }
    }
}
