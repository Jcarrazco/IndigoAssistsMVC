using Microsoft.EntityFrameworkCore;
using IndigoAssistMVC.Models;

namespace IndigoAssistMVC.Data
{
    public class IndigoDBContext : DbContext 
    {
        public IndigoDBContext(DbContextOptions<IndigoDBContext> options) : base(options)
        {
        }

        public DbSet<Activo> Activos { get; set; }
        public DbSet<TipoActivo> TiposActivo { get; set; }
        public DbSet<Departamento> Departamentos { get; set; }
        public DbSet<Status> Status { get; set; }
        public DbSet<Proveedor> Proveedores { get; set; }
        public DbSet<Componente> Componentes { get; set; }
        public DbSet<Software> Software { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Configuración de la entidad Activo usando Fluent API
            modelBuilder.Entity<Activo>(entity =>
            {
                entity.ToTable("mActivos");

                entity.HasKey(e => e.IdActivo);
                entity.Property(e => e.IdActivo)
                    .ValueGeneratedOnAdd()
                    .HasComment("Identificador único del activo");

                entity.Property(e => e.Codigo)
                    .IsRequired()
                    .HasMaxLength(40)
                    .IsUnicode(true)
                    .HasComment("Código único del activo");

                entity.Property(e => e.Nombre)
                    .IsRequired()
                    .HasMaxLength(120)
                    .IsUnicode(true)
                    .HasComment("Nombre descriptivo del activo");

                entity.Property(e => e.FeAlta)
                    .IsRequired()
                    .HasColumnType("date")
                    .HasComment("Fecha de alta del activo");

                entity.Property(e => e.Marca)
                    .HasMaxLength(50)
                    .IsUnicode(true)
                    .HasComment("Marca del activo");

                entity.Property(e => e.Modelo)
                    .HasMaxLength(80)
                    .IsUnicode(true)
                    .HasComment("Modelo del activo");

                entity.Property(e => e.Serie)
                    .HasMaxLength(80)
                    .IsUnicode(true)
                    .HasComment("Número de serie del activo");

                entity.Property(e => e.PersonaAsign)
                    .HasMaxLength(120)
                    .IsUnicode(true)
                    .HasComment("Persona asignada al activo");

                entity.Property(e => e.Ubicacion)
                    .HasMaxLength(120)
                    .IsUnicode(true)
                    .HasComment("Ubicación física del activo");

                entity.Property(e => e.FeCompra)
                    .HasColumnType("date")
                    .HasComment("Fecha de compra del activo");

                entity.Property(e => e.FeBaja)
                    .HasColumnType("date")
                    .HasComment("Fecha de baja del activo");

                entity.Property(e => e.CostoCompra)
                    .HasColumnType("decimal(12,2)")
                    .HasComment("Costo de compra del activo");

                entity.Property(e => e.Notas)
                    .HasMaxLength(400)
                    .IsUnicode(true)
                    .HasComment("Notas adicionales sobre el activo");

                entity.Property(e => e.CodificacionComponentes)
                    .HasComment("Codificación de componentes");

                entity.Property(e => e.TieneSoftwareOP)
                    .HasComment("Indica si tiene software OP");

                // Configuración de las claves foráneas
                entity.Property(e => e.IdTipoActivo)
                    .HasComment("Tipo de activo");

                entity.Property(e => e.IdDepartamento)
                    .HasComment("Departamento");

                entity.Property(e => e.IdStatus)
                    .HasComment("Status del activo");

                entity.Property(e => e.IdProveedor)
                    .HasComment("Proveedor");

                // Configuración de las relaciones
                entity.HasOne(e => e.TipoActivo)
                    .WithMany(t => t.Activos)
                    .HasForeignKey(e => e.IdTipoActivo)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(e => e.Departamento)
                    .WithMany(d => d.Activos)
                    .HasForeignKey(e => e.IdDepartamento)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(e => e.Status)
                    .WithMany(s => s.Activos)
                    .HasForeignKey(e => e.IdStatus)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(e => e.Proveedor)
                    .WithMany(p => p.Activos)
                    .HasForeignKey(e => e.IdProveedor)
                    .OnDelete(DeleteBehavior.Restrict);
            });
        }
    }
}
