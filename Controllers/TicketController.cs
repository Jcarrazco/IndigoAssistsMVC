using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;
using IndigoAssistMVC.Data;
using IndigoAssistMVC.Models;
using System.Security.Cryptography;
using System.Text;

namespace IndigoAssistMVC.Controllers
{
    /// <summary>
    /// Controlador para el módulo de Tickets
    /// Maneja la autenticación, consultas y gestión de tickets
    /// </summary>
    [Authorize(Roles = "Administrador,Supervisor,Tecnico")]
    public class TicketController : Controller
    {
        private readonly IndigoDBContext _context;
        private readonly ILogger<TicketController> _logger;

        public TicketController(IndigoDBContext context, ILogger<TicketController> logger)
        {
            _context = context;
            _logger = logger;
        }

        /// <summary>
        /// Página principal del módulo de tickets
        /// Muestra el dashboard con estadísticas y tickets abiertos
        /// </summary>
        public async Task<IActionResult> Index()
        {
            // Verificar si el usuario está autenticado
            var idPersona = HttpContext.Session.GetInt32("IdPersona");
            if (idPersona == null)
            {
                return RedirectToAction("Login");
            }

            try
            {
                var dashboard = await ObtenerDashboardTickets(idPersona.Value);
                return View(dashboard);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al obtener el dashboard de tickets para IdPersona: {IdPersona}", idPersona);
                TempData["Error"] = "Error al cargar el dashboard de tickets";
                return View(new TicketDashboardViewModel());
            }
        }

        /// <summary>
        /// Página de login para el sistema de tickets
        /// </summary>
        [HttpGet]
        public IActionResult Login(string? returnUrl = null)
        {
            // Si ya está autenticado, redirigir al dashboard
            if (HttpContext.Session.GetInt32("IdPersona") != null)
            {
                return RedirectToAction("Index");
            }

            var model = new TicketLoginViewModel
            {
                ReturnUrl = returnUrl
            };

            return View(model);
        }

        /// <summary>
        /// Procesa el login del usuario
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(TicketLoginViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            try
            {
                // Buscar el empleado por login
                var empleado = await _context.mEmpleados
                    .Include(e => e.PersonaEmpresa)
                        .ThenInclude(pe => pe.PersonaInfo)
                    .FirstOrDefaultAsync(e => e.Login == model.Usuario && e.Activo);

                if (empleado == null)
                {
                    ModelState.AddModelError("", "Usuario no encontrado o inactivo");
                    return View(model);
                }

                // En un sistema real, aquí se validaría la contraseña
                // Por ahora, aceptamos cualquier contraseña para usuarios activos
                if (string.IsNullOrEmpty(model.Password))
                {
                    ModelState.AddModelError("", "Contraseña requerida");
                    return View(model);
                }

                // Guardar información del usuario en la sesión
                HttpContext.Session.SetInt32("IdPersona", empleado.IdPersona);
                HttpContext.Session.SetString("Login", empleado.Login ?? "");
                HttpContext.Session.SetString("NombreCompleto", empleado.PersonaEmpresa?.PersonaInfo?.NombreCompleto ?? "");

                _logger.LogInformation("Usuario {Usuario} autenticado exitosamente", model.Usuario);

                // Redirigir según el ReturnUrl o al dashboard
                if (!string.IsNullOrEmpty(model.ReturnUrl) && Url.IsLocalUrl(model.ReturnUrl))
                {
                    return Redirect(model.ReturnUrl);
                }

                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error durante el login del usuario: {Usuario}", model.Usuario);
                ModelState.AddModelError("", "Error durante el proceso de autenticación");
                return View(model);
            }
        }

        /// <summary>
        /// Cierra la sesión del usuario
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Logout()
        {
            var usuario = HttpContext.Session.GetString("Login");
            
            // Limpiar la sesión
            HttpContext.Session.Clear();
            
            _logger.LogInformation("Usuario {Usuario} cerró sesión", usuario);
            
            TempData["Mensaje"] = "Sesión cerrada exitosamente";
            return RedirectToAction("Login");
        }

        /// <summary>
        /// Obtiene tickets abiertos por departamento del usuario
        /// </summary>
        public async Task<IActionResult> TicketsAbiertosDepto()
        {
            var idPersona = HttpContext.Session.GetInt32("IdPersona");
            if (idPersona == null)
            {
                return RedirectToAction("Login");
            }

            try
            {
                var tickets = await ObtenerTicketsAbiertosPorDepartamento(idPersona.Value);
                ViewBag.Titulo = "Tickets Abiertos por Departamento";
                ViewBag.TipoConsulta = "departamento";
                ViewBag.EstadoActual = "Abierto";
                return View("TicketsGenerico", tickets);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al obtener tickets abiertos por departamento");
                TempData["Error"] = "Error al cargar tickets abiertos";
                return View("TicketsGenerico", new List<TicketVista>());
            }
        }

        /// <summary>
        /// Obtiene tickets en proceso por departamento del usuario
        /// </summary>
        public async Task<IActionResult> TicketsEnProcesoDepto()
        {
            var idPersona = HttpContext.Session.GetInt32("IdPersona");
            if (idPersona == null)
            {
                return RedirectToAction("Login");
            }

            try
            {
                var tickets = await ObtenerTicketsEnProcesoPorDepartamento(idPersona.Value);
                ViewBag.Titulo = "Tickets En Proceso por Departamento";
                ViewBag.TipoConsulta = "departamento";
                ViewBag.EstadoActual = "En Proceso";
                return View("TicketsGenerico", tickets);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al obtener tickets en proceso por departamento");
                TempData["Error"] = "Error al cargar tickets en proceso";
                return View("TicketsGenerico", new List<TicketVista>());
            }
        }

        /// <summary>
        /// Obtiene tickets en proceso asignados al técnico actual
        /// </summary>
        public async Task<IActionResult> TicketsAsignados()
        {
            var idPersona = HttpContext.Session.GetInt32("IdPersona");
            if (idPersona == null)
            {
                return RedirectToAction("Login");
            }

            try
            {
                var tickets = await ObtenerTicketsAsignadosAlTecnico(idPersona.Value);
                ViewBag.Titulo = "Tickets Asignados a Mí";
                ViewBag.TipoConsulta = "asignados";
                ViewBag.EstadoActual = "En Proceso";
                return View("TicketsGenerico", tickets);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al obtener tickets asignados al técnico");
                TempData["Error"] = "Error al cargar tickets asignados";
                return View("TicketsGenerico", new List<TicketVista>());
            }
        }

        /// <summary>
        /// Obtiene tickets cerrados por departamento
        /// </summary>
        public async Task<IActionResult> TicketsCerradosDepto()
        {
            var idPersona = HttpContext.Session.GetInt32("IdPersona");
            if (idPersona == null)
            {
                return RedirectToAction("Login");
            }

            try
            {
                var tickets = await ObtenerTicketsCerradosPorDepartamento(idPersona.Value);
                ViewBag.Titulo = "Tickets Cerrados por Departamento";
                ViewBag.TipoConsulta = "departamento";
                ViewBag.EstadoActual = "Cerrado";
                return View("TicketsGenerico", tickets);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al obtener tickets cerrados por departamento");
                TempData["Error"] = "Error al cargar tickets cerrados";
                return View("TicketsGenerico", new List<TicketVista>());
            }
        }

        /// <summary>
        /// Obtiene tickets cerrados por el usuario actual
        /// </summary>
        public async Task<IActionResult> TicketsCerradosUsuario()
        {
            var idPersona = HttpContext.Session.GetInt32("IdPersona");
            if (idPersona == null)
            {
                return RedirectToAction("Login");
            }

            try
            {
                var tickets = await ObtenerTicketsCerradosPorUsuario(idPersona.Value);
                ViewBag.Titulo = "Mis Tickets Cerrados";
                ViewBag.TipoConsulta = "usuario";
                ViewBag.EstadoActual = "Cerrado";
                return View("TicketsGenerico", tickets);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al obtener tickets cerrados por usuario");
                TempData["Error"] = "Error al cargar tickets cerrados";
                return View("TicketsGenerico", new List<TicketVista>());
            }
        }

        #region Métodos Privados

        /// <summary>
        /// Obtiene el dashboard completo de tickets para el usuario
        /// </summary>
        private async Task<TicketDashboardViewModel> ObtenerDashboardTickets(int idPersona)
        {
            var dashboard = new TicketDashboardViewModel();

            // Obtener información del usuario
            var usuario = await _context.mPerEmp
                .Include(pe => pe.PersonaInfo)
                .FirstOrDefaultAsync(pe => pe.IdPersona == idPersona);

            if (usuario != null)
            {
                dashboard.Usuario = usuario;
            }

            // Obtener todos los datos en paralelo para mejor rendimiento
            var tasks = new[]
            {
                ObtenerTicketsAbiertosPorDepartamento(idPersona),
                ObtenerTicketsEnProcesoPorDepartamento(idPersona),
                ObtenerTicketsAsignadosAlTecnico(idPersona),
                ObtenerTicketsCerradosPorDepartamento(idPersona),
                ObtenerTicketsCerradosPorUsuario(idPersona)
            };

            await Task.WhenAll(tasks);

            dashboard.TicketsAbiertosDepto = await tasks[0];
            dashboard.TicketsEnProcesoDepto = await tasks[1];
            dashboard.TicketsEnProcesoAsignados = await tasks[2];
            dashboard.TicketsCerradosDepto = await tasks[3];
            dashboard.TicketsCerradosUsuario = await tasks[4];

            // Calcular estadísticas
            dashboard.Estadisticas = CalcularEstadisticas(dashboard);

            return dashboard;
        }

        /// <summary>
        /// Obtiene tickets abiertos (Status = 1) por departamento del usuario
        /// </summary>
        private async Task<List<TicketVista>> ObtenerTicketsAbiertosPorDepartamento(int idPersona)
        {
            // Obtener el departamento del usuario
            var usuarioDepto = await _context.mEmpleados
                .Include(e => e.PersonaEmpresa)
                .ThenInclude(pe => pe.PersonaInfo)
                .Where(e => e.IdPersona == idPersona)
                .SelectMany(e => _context.dEmpleados
                    .Where(de => de.IdPersona == e.IdPersona)
                    .Select(de => _context.mPuestos
                        .Where(p => p.IdPuesto == de.IdPuesto)
                        .Select(p => p.IdDepto)
                        .FirstOrDefault()))
                .FirstOrDefaultAsync();

            if (usuarioDepto == 0)
            {
                return new List<TicketVista>();
            }

            // Obtener tickets abiertos del departamento
            var tickets = await _context.TicketsVista
                .Where(t => t.Status == 1 && t.IdDepto == usuarioDepto)
                .OrderByDescending(t => t.FeAlta)
                .ToListAsync();

            return tickets;
        }

        /// <summary>
        /// Obtiene tickets en proceso (Status = 2) por departamento del usuario
        /// </summary>
        private async Task<List<TicketVista>> ObtenerTicketsEnProcesoPorDepartamento(int idPersona)
        {
            // Obtener el departamento del usuario
            var usuarioDepto = await _context.mEmpleados
                .Include(e => e.PersonaEmpresa)
                .ThenInclude(pe => pe.PersonaInfo)
                .Where(e => e.IdPersona == idPersona)
                .SelectMany(e => _context.dEmpleados
                    .Where(de => de.IdPersona == e.IdPersona)
                    .Select(de => _context.mPuestos
                        .Where(p => p.IdPuesto == de.IdPuesto)
                        .Select(p => p.IdDepto)
                        .FirstOrDefault()))
                .FirstOrDefaultAsync();

            if (usuarioDepto == 0)
            {
                return new List<TicketVista>();
            }

            // Obtener tickets en proceso del departamento
            var tickets = await _context.TicketsVista
                .Where(t => t.Status == 2 && t.IdDepto == usuarioDepto)
                .OrderByDescending(t => t.FeAsignacion)
                .ToListAsync();

            return tickets;
        }

        /// <summary>
        /// Obtiene tickets en proceso asignados al técnico actual
        /// </summary>
        private async Task<List<TicketVista>> ObtenerTicketsAsignadosAlTecnico(int idPersona)
        {
            var tickets = await _context.TicketsVista
                .Where(t => t.Status == 2 && t.IdTecnico == idPersona)
                .OrderByDescending(t => t.FeAsignacion)
                .ToListAsync();

            return tickets;
        }

        /// <summary>
        /// Obtiene tickets cerrados (Status = 3) por departamento del usuario
        /// </summary>
        private async Task<List<TicketVista>> ObtenerTicketsCerradosPorDepartamento(int idPersona)
        {
            // Obtener el departamento del usuario
            var usuarioDepto = await _context.mEmpleados
                .Include(e => e.PersonaEmpresa)
                .ThenInclude(pe => pe.PersonaInfo)
                .Where(e => e.IdPersona == idPersona)
                .SelectMany(e => _context.dEmpleados
                    .Where(de => de.IdPersona == e.IdPersona)
                    .Select(de => _context.mPuestos
                        .Where(p => p.IdPuesto == de.IdPuesto)
                        .Select(p => p.IdDepto)
                        .FirstOrDefault()))
                .FirstOrDefaultAsync();

            if (usuarioDepto == 0)
            {
                return new List<TicketVista>();
            }

            // Obtener tickets cerrados del departamento (usando vista histórica)
            var tickets = await _context.TicketsVista
                .Where(t => t.Status == 3 && t.IdDepto == usuarioDepto)
                .OrderByDescending(t => t.FeCierre)
                .Take(50) // Limitar a los últimos 50 para rendimiento
                .ToListAsync();

            return tickets;
        }

        /// <summary>
        /// Obtiene tickets cerrados por el usuario actual
        /// </summary>
        private async Task<List<TicketVista>> ObtenerTicketsCerradosPorUsuario(int idPersona)
        {
            var tickets = await _context.TicketsVista
                .Where(t => t.Status == 3 && t.IdSolicitante == idPersona)
                .OrderByDescending(t => t.FeCierre)
                .Take(50) // Limitar a los últimos 50 para rendimiento
                .ToListAsync();

            return tickets;
        }

        /// <summary>
        /// Calcula las estadísticas del dashboard
        /// </summary>
        private TicketEstadisticasViewModel CalcularEstadisticas(TicketDashboardViewModel dashboard)
        {
            var estadisticas = new TicketEstadisticasViewModel
            {
                TotalAbiertos = dashboard.TicketsAbiertosDepto.Count,
                TotalEnProceso = dashboard.TicketsEnProcesoDepto.Count,
                TotalAsignados = dashboard.TicketsEnProcesoAsignados.Count,
                TotalCerrados = dashboard.TicketsCerradosDepto.Count + dashboard.TicketsCerradosUsuario.Count
            };

            // Estadísticas por departamento
            var todosLosTickets = dashboard.TicketsAbiertosDepto
                .Concat(dashboard.TicketsEnProcesoDepto)
                .Concat(dashboard.TicketsCerradosDepto)
                .ToList();

            estadisticas.PorDepartamento = todosLosTickets
                .GroupBy(t => t.Departamento)
                .ToDictionary(g => g.Key, g => g.Count());

            // Estadísticas por prioridad
            estadisticas.PorPrioridad = todosLosTickets
                .Where(t => t.IdPrioridad.HasValue)
                .GroupBy(t => t.IdPrioridad.Value)
                .ToDictionary(g => g.Key.ToString(), g => g.Count());

            return estadisticas;
        }

        #endregion
    }
}
