using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Identity;
using IndigoAssistMVC.Models;

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

// Configuración de Entity Framework
builder.Services.AddDbContext<IndigoAssistMVC.Data.IndigoDBContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Configuración de Identity con roles
builder.Services.AddIdentity<Usuario, IdentityRole>(options =>
{
    // Configuración de contraseñas
    options.Password.RequireDigit = false;
    options.Password.RequireLowercase = false;
    options.Password.RequireNonAlphanumeric = false;
    options.Password.RequireUppercase = false;
    options.Password.RequiredLength = 1;
    options.Password.RequiredUniqueChars = 0;
    
    // Configuración de usuario
    options.User.RequireUniqueEmail = false;
    options.SignIn.RequireConfirmedEmail = false;
    options.SignIn.RequireConfirmedPhoneNumber = false;
})
.AddEntityFrameworkStores<IndigoAssistMVC.Data.IndigoDBContext>()
.AddDefaultTokenProviders();

// Configuración de cookies de Identity
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

// Seeding movido a scripts SQL (ScriptBD/IndigoBasic_Nueva.sql)

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
