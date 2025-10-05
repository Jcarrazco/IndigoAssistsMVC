using Microsoft.AspNetCore.Identity;
using IndigoAssistMVC.Models;
using IndigoAssistMVC.Data;

namespace IndigoAssistMVC.Data
{
    /// <summary>
    /// Seeder para inicializar roles y usuarios del sistema
    /// </summary>
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

            // Crear usuarios si no existen
            await CreateUserIfNotExists(userManager, "admin", "admin123", "Administrador", "Administrador del Sistema", "admin@empresa.com");
            await CreateUserIfNotExists(userManager, "supervisor", "super123", "Supervisor", "Supervisor de Sistemas", "supervisor@empresa.com");
            await CreateUserIfNotExists(userManager, "tecnico", "tec123", "Tecnico", "Técnico de Soporte", "tecnico@empresa.com");
            await CreateUserIfNotExists(userManager, "maria.r", "maria123", "Supervisor", "María Elena Rodríguez", "maria.rodriguez@empresa.com");
            await CreateUserIfNotExists(userManager, "carlos.h", "carlos123", "Tecnico", "Carlos Alberto Hernández", "carlos.hernandez@empresa.com");
            await CreateUserIfNotExists(userManager, "ana.s", "ana123", "Tecnico", "Ana Patricia Sánchez", "ana.sanchez@empresa.com");
        }

        private static async Task CreateUserIfNotExists(UserManager<Usuario> userManager, string userName, string password, string role, string nombreCompleto, string email)
        {
            var user = await userManager.FindByNameAsync(userName);
            if (user == null)
            {
                user = new Usuario
                {
                    UserName = userName,
                    Email = email,
                    NombreCompleto = nombreCompleto,
                    EmailConfirmed = true,
                    Activo = true,
                    FechaRegistro = DateTime.Now
                };

                var result = await userManager.CreateAsync(user, password);
                if (result.Succeeded)
                {
                    await userManager.AddToRoleAsync(user, role);
                }
            }
        }
    }
}
