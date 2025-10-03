using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace IndigoAssistMVC.Models
{
    [Table("TiposActivo")]
    public class TipoActivo
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public byte IdTipoActivo { get; set; }

        [Required]
        [StringLength(50)]
        [DisplayName("Tipo de Activo")]
        [Column("TipoActivo")]
        public string TipoActivoNombre { get; set; } = string.Empty;

        // Navegación
        public virtual ICollection<Activo> Activos { get; set; } = new List<Activo>();
    }

    [Table("Departamentos")]
    public class Departamento
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public byte IdDepartamento { get; set; }

        [Required]
        [StringLength(80)]
        [DisplayName("Departamento")]
        [Column("Departamento")]
        public string DepartamentoNombre { get; set; } = string.Empty;

        // Navegación
        public virtual ICollection<Activo> Activos { get; set; } = new List<Activo>();
    }

    [Table("Status")]
    public class Status
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public byte StatusId { get; set; }

        [Required]
        [StringLength(20)]
        [DisplayName("Status")]
        [Column("Status")]
        public char StatusNombre { get; set; } = 'A';

        // Navegación
        public virtual ICollection<Activo> Activos { get; set; } = new List<Activo>();
    }

    [Table("Proveedores")]
    public class Proveedor
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public byte IdProveedor { get; set; }

        [Required]
        [StringLength(120)]
        [DisplayName("Proveedor")]
        [Column("Proveedor")]
        public string ProveedorNombre { get; set; } = string.Empty;

        // Navegación
        public virtual ICollection<Activo> Activos { get; set; } = new List<Activo>();
    }

    [Table("Componentes")]
    public class Componente
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public byte IdComponente { get; set; }

        [Required]
        [StringLength(80)]
        [DisplayName("Componente")]
        [Column("Componente")]
        public string ComponenteNombre { get; set; } = string.Empty;

        [DisplayName("Valor Bit")]
        public int? ValorBit { get; set; }
    }

    [Table("Software")]
    public class Software
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public byte IdSoftware { get; set; }

        [Required]
        [StringLength(80)]
        [DisplayName("Software")]
        public string Nombre { get; set; } = string.Empty;
    }
}
