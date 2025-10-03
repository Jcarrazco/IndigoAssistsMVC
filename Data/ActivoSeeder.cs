using IndigoAssistMVC.Models;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel;

namespace IndigoAssistMVC.Data
{
    public static class ActivoSeeder
    {
        public static async Task SeedAsync(IndigoDBContext context)
        {
            if (await context.Activos.AnyAsync())
            {
                return; 
            }

            var activos = new List<Activo>
            {
                
            };

            await context.Activos.AddRangeAsync(activos);
            
            await context.SaveChangesAsync();
        }
    }
}
