using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Identity;
using IndigoAssistMVC.Models;
using IndigoAsists.Repositorio;
using IndigoAssits.Repositorio.Core.Entities;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

// Configuración de sesión
builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromHours(1); // Sesión de 1 hora
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
    options.Cookie.SecurePolicy = CookieSecurePolicy.SameAsRequest;
});

// Configuración de Entity Framework - Contexto MVC (mantener para compatibilidad)
builder.Services.AddDbContext<IndigoAssistMVC.Data.IndigoDBContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Configuración de servicios del repositorio (incluye Identity)
builder.Services.AddRepositorioServices(builder.Configuration);

// Configuración adicional de cookies de Identity (sobrescribe la del repositorio)
builder.Services.ConfigureApplicationCookie(options =>
{
    options.LoginPath = "/Usuario/Login";
    options.LogoutPath = "/Usuario/Logout";
    options.AccessDeniedPath = "/Home/AccessDenied";
    options.ExpireTimeSpan = TimeSpan.FromHours(1);
    options.SlidingExpiration = true;
    options.Cookie.HttpOnly = true;
    options.Cookie.SecurePolicy = CookieSecurePolicy.SameAsRequest;
});

var app = builder.Build();

// Seeding automático de usuarios de Identity
using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<IndigoAssistMVC.Data.IndigoDBContext>();
    var userManager = scope.ServiceProvider.GetRequiredService<UserManager<IndigoAssistMVC.Models.Usuario>>();
    var roleManager = scope.ServiceProvider.GetRequiredService<RoleManager<IdentityRole>>();
    
    // Aplicar migraciones automáticamente
    context.Database.Migrate();
    
    // Crear datos de catálogos de activos PRIMERO
    await IndigoAssistMVC.Data.ActivoSeeder.SeedAsync(context);
    
    // Crear usuarios y roles de prueba DESPUÉS
    await IndigoAssistMVC.Data.IdentitySeeder.SeedAsync(context, userManager, roleManager);
}

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
}
app.UseStaticFiles();

app.UseRouting();

app.UseSession(); // Middleware de sesión debe ir antes de Authentication
app.UseAuthentication();
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
