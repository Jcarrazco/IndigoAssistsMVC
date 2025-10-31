using IndigoAssits.Core.Dtos;
using IndigoAssitsReglasDeNegocio.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace IndigoAssits.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IUsuarioService _usuarioService;
        private readonly IConfiguration _configuration;

        public AuthController(IUsuarioService usuarioService, IConfiguration configuration)
        {
            _usuarioService = usuarioService;
            _configuration = configuration;
        }

        public class LoginRequest
        {
            public string UserName { get; set; } = string.Empty;
            public string Password { get; set; } = string.Empty;
        }

        public class LoginResponse
        {
            public string AccessToken { get; set; } = string.Empty;
            public DateTime ExpiresAt { get; set; }
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.UserName) || string.IsNullOrWhiteSpace(request.Password))
                return BadRequest("Credenciales inválidas");

            var valido = await _usuarioService.ValidarCredencialesAsync(request.UserName, request.Password);
            if (!valido) return Unauthorized();

            var user = await _usuarioService.GetPorUserNameAsync(request.UserName);
            if (user == null) return Unauthorized();

            var roles = await _usuarioService.GetRolesAsync(user.Id);

            var jwtSection = _configuration.GetSection("Jwt");
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSection["Key"]!));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
            var expires = DateTime.UtcNow.AddMinutes(int.TryParse(jwtSection["AccessTokenMinutes"], out var m) ? m : 60);

            var claims = new List<Claim>
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.Id),
                new Claim(JwtRegisteredClaimNames.UniqueName, user.Usuario),
                new Claim(JwtRegisteredClaimNames.Email, user.Email)
            };
            claims.AddRange(roles.Select(r => new Claim(ClaimTypes.Role, r)));

            var token = new JwtSecurityToken(
                issuer: jwtSection["Issuer"],
                audience: jwtSection["Audience"],
                claims: claims,
                expires: expires,
                signingCredentials: creds);

            var accessToken = new JwtSecurityTokenHandler().WriteToken(token);
            return Ok(new LoginResponse { AccessToken = accessToken, ExpiresAt = expires });
        }
    }
}


