using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using IndigoAssits.Repositorio.Core.Interfaces;
using IndigoAsists.Repositorio.Db;
using IndigoAsists.Repositorio.Repositories;

namespace IndigoAsists.Repositorio
{
    /// <summary>
    /// Configuración de servicios para el proyecto de repositorio
    /// </summary>
    public static class ServiceConfiguration
    {
        /// <summary>
        /// Registra todos los servicios del repositorio
        /// </summary>
        /// <param name="services">Colección de servicios</param>
        /// <param name="configuration">Configuración de la aplicación</param>
        /// <returns>Colección de servicios configurada</returns>
        public static IServiceCollection AddRepositorioServices(this IServiceCollection services, IConfiguration configuration)
        {
            // Configurar Entity Framework
            services.AddDbContext<IndigoDbContext>(options =>
            {
                var connectionString = configuration.GetConnectionString("DefaultConnection");
                options.UseSqlServer(connectionString, sqlOptions =>
                {
                    sqlOptions.CommandTimeout(30);
                    sqlOptions.EnableRetryOnFailure(
                        maxRetryCount: 3,
                        maxRetryDelay: TimeSpan.FromSeconds(30),
                        errorNumbersToAdd: null);
                });

                // Habilitar logging detallado en desarrollo
                if (Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") == "Development")
                {
                    options.EnableSensitiveDataLogging();
                    options.EnableDetailedErrors();
                }
            });

            // Registrar repositorios
            services.AddScoped<ITicketRepository, TicketRepository>();
            services.AddScoped<ICategoriaRepository, CategoriaRepository>();
            services.AddScoped<IUsuarioRepository, UsuarioRepository>();
            services.AddScoped<IDepartamentoRepository, DepartamentoRepository>();
            services.AddScoped<IEmpleadoRepository, EmpleadoRepository>();
            services.AddScoped<IActivoRepository, ActivoRepository>();

            // Registrar UnitOfWork
            services.AddScoped<IUnitOfWork, UnitOfWork>();

            // Registrar repositorio genérico
            services.AddScoped(typeof(IGenericRepository<>), typeof(GenericRepository<>));

            return services;
        }
    }
}