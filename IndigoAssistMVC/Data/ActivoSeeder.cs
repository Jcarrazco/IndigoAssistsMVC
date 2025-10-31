using Microsoft.EntityFrameworkCore;
using IndigoAssistMVC.Models;

namespace IndigoAssistMVC.Data
{
    public static class ActivoSeeder
    {
        public static async Task SeedAsync(IndigoDBContext context)
        {
            // Verificar si ya existen datos
            if (await context.TiposActivo.AnyAsync())
            {
                return; // Ya hay datos, no hacer nada
            }

            // Crear tipos de activo
            var tiposActivo = new[]
            {
                new TipoActivo { TipoActivoNombre = "Laptop" },
                new TipoActivo { TipoActivoNombre = "PC de Escritorio" },
                new TipoActivo { TipoActivoNombre = "Servidor" },
                new TipoActivo { TipoActivoNombre = "Impresora" },
                new TipoActivo { TipoActivoNombre = "Router" },
                new TipoActivo { TipoActivoNombre = "Monitor" },
                new TipoActivo { TipoActivoNombre = "Tablet" },
                new TipoActivo { TipoActivoNombre = "Smartphone" },
                new TipoActivo { TipoActivoNombre = "Switch de Red" },
                new TipoActivo { TipoActivoNombre = "Firewall" },
                new TipoActivo { TipoActivoNombre = "UPS" },
                new TipoActivo { TipoActivoNombre = "Escáner" }
            };

            context.TiposActivo.AddRange(tiposActivo);

            // Crear status
            var status = new[]
            {
                new Status { StatusNombre = "Activo" },
                new Status { StatusNombre = "Inactivo" },
                new Status { StatusNombre = "Mantenimiento" },
                new Status { StatusNombre = "Baja" }
            };

            context.Status.AddRange(status);

            // Crear proveedores
            var proveedores = new[]
            {
                new Proveedor { ProveedorNombre = "Dell Technologies" },
                new Proveedor { ProveedorNombre = "HP Inc." },
                new Proveedor { ProveedorNombre = "Lenovo" },
                new Proveedor { ProveedorNombre = "Microsoft" },
                new Proveedor { ProveedorNombre = "Cisco Systems" },
                new Proveedor { ProveedorNombre = "Apple Inc." },
                new Proveedor { ProveedorNombre = "Samsung Electronics" },
                new Proveedor { ProveedorNombre = "Asus" },
                new Proveedor { ProveedorNombre = "Acer" },
                new Proveedor { ProveedorNombre = "Intel Corporation" }
            };

            context.Proveedores.AddRange(proveedores);

            // Crear componentes
            var componentes = new[]
            {
                new Componente { ComponenteNombre = "Procesador", ValorBit = 1 },
                new Componente { ComponenteNombre = "Memoria RAM", ValorBit = 2 },
                new Componente { ComponenteNombre = "Disco Duro", ValorBit = 4 },
                new Componente { ComponenteNombre = "Tarjeta de Video", ValorBit = 8 },
                new Componente { ComponenteNombre = "Tarjeta de Red", ValorBit = 16 },
                new Componente { ComponenteNombre = "Fuente de Poder", ValorBit = 32 },
                new Componente { ComponenteNombre = "Placa Base", ValorBit = 64 },
                new Componente { ComponenteNombre = "Monitor", ValorBit = 128 }
            };

            context.Componentes.AddRange(componentes);

            // Crear software
            var software = new[]
            {
                new Software { Nombre = "Windows 11 Pro" },
                new Software { Nombre = "Windows 10 Pro" },
                new Software { Nombre = "Microsoft Office 365" },
                new Software { Nombre = "Adobe Creative Suite" },
                new Software { Nombre = "Antivirus Enterprise" },
                new Software { Nombre = "Visual Studio 2022" },
                new Software { Nombre = "SQL Server Management Studio" },
                new Software { Nombre = "Google Chrome" },
                new Software { Nombre = "Firefox" },
                new Software { Nombre = "Microsoft Edge" }
            };

            context.Software.AddRange(software);

            // Crear departamentos (necesarios para usuarios de Identity)
            var departamentos = new[]
            {
                new mDepartamentos { IdDepto = 1, Departamento = "Administrativo", Tickets = false },
                new mDepartamentos { IdDepto = 2, Departamento = "Almacen", Tickets = false },
                new mDepartamentos { IdDepto = 3, Departamento = "Asesoria Sanitaria", Tickets = false },
                new mDepartamentos { IdDepto = 4, Departamento = "Atencion a Clientes", Tickets = false },
                new mDepartamentos { IdDepto = 5, Departamento = "Cocina", Tickets = false },
                new mDepartamentos { IdDepto = 6, Departamento = "Compras", Tickets = false },
                new mDepartamentos { IdDepto = 7, Departamento = "Comunicacion", Tickets = false },
                new mDepartamentos { IdDepto = 8, Departamento = "Contabilidad", Tickets = false },
                new mDepartamentos { IdDepto = 9, Departamento = "Conteos Ciclicos", Tickets = false },
                new mDepartamentos { IdDepto = 10, Departamento = "Credito y Cobranza", Tickets = false },
                new mDepartamentos { IdDepto = 11, Departamento = "Diseño y Comunicacion", Tickets = true },
                new mDepartamentos { IdDepto = 12, Departamento = "Direccion General", Tickets = false },
                new mDepartamentos { IdDepto = 13, Departamento = "Mantenimiento de Edificios", Tickets = true },
                new mDepartamentos { IdDepto = 14, Departamento = "Mantenimiento de Vehiculos", Tickets = true },
                new mDepartamentos { IdDepto = 15, Departamento = "Recibo", Tickets = false },
                new mDepartamentos { IdDepto = 16, Departamento = "Recursos Humanos", Tickets = true },
                new mDepartamentos { IdDepto = 17, Departamento = "Reparto", Tickets = false },
                new mDepartamentos { IdDepto = 18, Departamento = "Sistemas", Tickets = true },
                new mDepartamentos { IdDepto = 19, Departamento = "Ventas", Tickets = false },
                new mDepartamentos { IdDepto = 20, Departamento = "Vigilancia", Tickets = true },
                new mDepartamentos { IdDepto = 21, Departamento = "Activos Fijos", Tickets = false },
                new mDepartamentos { IdDepto = 22, Departamento = "Aseguramiento de Calidad", Tickets = false },
                new mDepartamentos { IdDepto = 23, Departamento = "Direccion de Administracion", Tickets = true },
                new mDepartamentos { IdDepto = 24, Departamento = "Gerencia de Operaciones", Tickets = false },
                new mDepartamentos { IdDepto = 25, Departamento = "Proyectos", Tickets = false }
            };

            context.mDepartamentos.AddRange(departamentos);

            await context.SaveChangesAsync();
            Console.WriteLine("Datos de catálogos de activos y departamentos creados exitosamente.");
        }
    }
}
