using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using IndigoAssistMVC.Models;

namespace IndigoAssistMVC.Data
{
    public static class IdentitySeeder
    {
        public static async Task SeedAsync(IndigoDBContext context, UserManager<Usuario> userManager, RoleManager<IdentityRole> roleManager)
        {
            // Crear roles si no existen
            string[] roles = { "Administrador", "Supervisor", "Tecnico" };
            
            foreach (var role in roles)
            {
                if (!await roleManager.RoleExistsAsync(role))
                {
                    await roleManager.CreateAsync(new IdentityRole(role));
                }
            }

            // Obtener el primer departamento disponible (Sistemas)
            var departamentoSistemas = await context.mDepartamentos.FirstOrDefaultAsync(d => d.Departamento == "Sistemas");
            var idDepartamento = departamentoSistemas?.IdDepto ?? 18; // Usar ID 18 como fallback

            // Crear usuarios de prueba si no existen
            await CreateUserIfNotExists(userManager, "admin@indigo.com", "Password123!", "Administrador", "Administrador", "Sistema", "Admin", idDepartamento);
            await CreateUserIfNotExists(userManager, "supervisor@indigo.com", "Password123!", "Supervisor", "Juan", "Pérez", "Supervisor", idDepartamento);
            await CreateUserIfNotExists(userManager, "tecnico@indigo.com", "Password123!", "Tecnico", "María", "García", "Técnico", idDepartamento);
            await CreateUserIfNotExists(userManager, "usuario@indigo.com", "Password123!", "Tecnico", "Carlos", "López", "Usuario", idDepartamento);
        }

        private static async Task CreateUserIfNotExists(UserManager<Usuario> userManager, string email, string password, string role, string nombre, string apellidoPaterno, string apellidoMaterno, byte? idDepartamento)
        {
            var user = await userManager.FindByEmailAsync(email);
            if (user == null)
            {
                user = new Usuario
                {
                    UserName = email,
                    Email = email,
                    EmailConfirmed = true,
                    NombreCompleto = $"{nombre} {apellidoPaterno} {apellidoMaterno}",
                    IdDepartamento = idDepartamento,
                    Activo = true,
                    FechaRegistro = DateTime.Now
                };

                var result = await userManager.CreateAsync(user, password);
                if (result.Succeeded)
                {
                    await userManager.AddToRoleAsync(user, role);
                    Console.WriteLine($"Usuario creado: {email} con rol {role}");
                }
                else
                {
                    Console.WriteLine($"Error creando usuario {email}: {string.Join(", ", result.Errors.Select(e => e.Description))}");
                }
            }
        }
    }
}
