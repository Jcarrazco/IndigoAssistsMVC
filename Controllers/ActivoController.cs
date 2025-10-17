using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;
using IndigoAssistMVC.Data;
using IndigoAssistMVC.Models;
using IndigoAssistMVC.ViewModels;

namespace IndigoAssistMVC.Controllers
{
    [Authorize(Roles = "Administrador,Supervisor")]
    public class ActivoController : Controller
    {
        private readonly IndigoDBContext _context;

        public ActivoController(IndigoDBContext context)
        {
            _context = context;
        }

        // GET: Activo
        public async Task<IActionResult> Index(string mode, ActivoFiltroViewModel filtro)
        {
            var viewModel = new ActivoIndexViewModel();
            
            // Cargar datos para los dropdowns
            await CargarDatosParaFiltros(viewModel.Filtro);

            if (mode == "filter")
            {
                // Aplicar filtros
                viewModel.Filtro = filtro;
                // Re-cargar listas del filtro con el modelo asignado para evitar nulos en SelectList
                await CargarDatosParaFiltros(viewModel.Filtro);
                var activos = await AplicarFiltros(filtro);
                viewModel.Resultados = activos.Select(a => ActivoViewModel.FromActivo(a)).ToList();
            }
            else
            {
                // Mostrar todos los activos
                var activos = await _context.Activos
                    .Include(a => a.TipoActivo)
                    .Include(a => a.Departamento)
                    .Include(a => a.Status)
                    .Include(a => a.Proveedor)
                    .ToListAsync();

                viewModel.Resultados = activos.Select(a => ActivoViewModel.FromActivo(a)).ToList();
            }

            return View(viewModel);
        }

        // GET: Activo/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var activo = await _context.Activos
                .Include(a => a.TipoActivo)
                .Include(a => a.Departamento)
                .Include(a => a.Status)
                .Include(a => a.Proveedor)
                .FirstOrDefaultAsync(m => m.IdActivo == id);
            
            if (activo == null)
            {
                return NotFound();
            }

            var activoViewModel = ActivoViewModel.FromActivo(activo);
            
            // Cargar componentes disponibles para mostrar los seleccionados
            activoViewModel.ComponentesDisponibles = await _context.Componentes.ToListAsync();

            return View(activoViewModel);
        }

        // GET: Activo/Create
        public async Task<IActionResult> Create()
        {
            var viewModel = await PrepareViewModelAsync();
            return View(viewModel);
        }

        // POST: Activo/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(ActivoViewModel viewModel, int[] ComponentesSeleccionados)
        {
            // Procesar selección múltiple de componentes
            if (ComponentesSeleccionados != null && ComponentesSeleccionados.Length > 0)
            {
                viewModel.CodificacionComponentes = ComponentesSeleccionados.Sum();
            }
            else
            {
                viewModel.CodificacionComponentes = 0;
            }

            if (ModelState.IsValid)
            {
                var activo = viewModel.ToActivo();
                _context.Add(activo);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }

            viewModel = await PrepareViewModelAsync(viewModel);
            return View(viewModel);
        }

        // GET: Activo/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var activo = await _context.Activos
                .Include(a => a.TipoActivo)
                .Include(a => a.Departamento)
                .Include(a => a.Status)
                .Include(a => a.Proveedor)
                .FirstOrDefaultAsync(a => a.IdActivo == id);
            
            if (activo == null)
            {
                return NotFound();
            }

            var viewModel = ActivoViewModel.FromActivo(activo);
            viewModel = await PrepareViewModelAsync(viewModel);

            return View(viewModel);
        }

        // POST: Activo/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, ActivoViewModel viewModel, int[] ComponentesSeleccionados)
        {
            if (id != viewModel.IdActivo)
            {
                return NotFound();
            }

            if (ComponentesSeleccionados != null && ComponentesSeleccionados.Length > 0)
            {
                viewModel.CodificacionComponentes = ComponentesSeleccionados.Sum();
            }
            else
            {
                viewModel.CodificacionComponentes = 0;
            }

            if (ModelState.IsValid)
            {
                try
                {
                    var activo = viewModel.ToActivo();
                    _context.Update(activo);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ActivoExists(viewModel.IdActivo))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }

            viewModel = await PrepareViewModelAsync(viewModel);
            return View(viewModel);
        }

        // GET: Activo/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var activo = await _context.Activos
                .Include(a => a.TipoActivo)
                .Include(a => a.Departamento)
                .Include(a => a.Status)
                .Include(a => a.Proveedor)
                .FirstOrDefaultAsync(m => m.IdActivo == id);
            
            if (activo == null)
            {
                return NotFound();
            }

            var activoViewModel = ActivoViewModel.FromActivo(activo);
            activoViewModel.ComponentesDisponibles = await _context.Componentes.ToListAsync();

            return View(activoViewModel);
        }

        // POST: Activo/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var activo = await _context.Activos.FindAsync(id);
            if (activo != null)
            {
                _context.Activos.Remove(activo);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ActivoExists(int id)
        {
            return _context.Activos.Any(e => e.IdActivo == id);
        }

        private async Task<ActivoViewModel> PrepareViewModelAsync(ActivoViewModel? viewModel = null)
        {
            viewModel ??= new ActivoViewModel();

            var tiposActivo = await _context.TiposActivo.ToListAsync();
            var departamentos = await _context.mDepartamentos.ToListAsync();
            var status = await _context.Status.ToListAsync();
            var proveedores = await _context.Proveedores.ToListAsync();
            var componentes = await _context.Componentes.ToListAsync();

            viewModel.TipoActivoList = new SelectList(tiposActivo, "IdTipoActivo", "TipoActivoNombre", viewModel.IdTipoActivo);
            viewModel.DepartamentoList = new SelectList(departamentos, "IdDepto", "Departamento", viewModel.IdDepartamento);
            viewModel.StatusList = new SelectList(status, "StatusId", "StatusNombre", viewModel.IdStatus);
            viewModel.ProveedorList = new SelectList(proveedores, "IdProveedor", "ProveedorNombre", viewModel.IdProveedor);

            // Preparar opciones de componentes
            viewModel.ComponentesOptions = componentes.Select(c => new SelectListItem
            {
                Text = c.ComponenteNombre,
                Value = c.ValorBit?.ToString() ?? "0",
                Selected = viewModel.CodificacionComponentes.HasValue && 
                          c.ValorBit.HasValue && 
                          (viewModel.CodificacionComponentes.Value & c.ValorBit.Value) == c.ValorBit.Value
            }).ToList();

            viewModel.ComponentesDisponibles = componentes;

            return viewModel;
        }

        private async Task CargarDatosParaFiltros(ActivoFiltroViewModel filtro)
        {
            var tiposActivo = await _context.TiposActivo.ToListAsync();
            var departamentos = await _context.mDepartamentos.ToListAsync();
            var status = await _context.Status.ToListAsync();
            var proveedores = await _context.Proveedores.ToListAsync();
            var componentes = await _context.Componentes.ToListAsync();

            filtro.TiposActivo = new SelectList(tiposActivo, "IdTipoActivo", "TipoActivoNombre", filtro.TipoActivoId);
            filtro.Departamentos = new SelectList(departamentos, "IdDepto", "Departamento", filtro.DepartamentoId);
            filtro.Statuses = new SelectList(status, "StatusId", "StatusNombre", filtro.StatusId);
            filtro.Proveedores = new SelectList(proveedores, "IdProveedor", "ProveedorNombre", filtro.ProveedorId);
            // Filtrar solo componentes con ValorBit válido y crear SelectListItems manualmente
            var componentesConValor = componentes.Where(c => c.ValorBit.HasValue).ToList();
            var componentesItems = componentesConValor.Select(c => new SelectListItem
            {
                Text = c.ComponenteNombre,
                Value = c.ValorBit!.Value.ToString()
            }).ToList();
            
            filtro.Componentes = new SelectList(componentesItems, "Value", "Text");
        }

        private async Task<List<Activo>> AplicarFiltros(ActivoFiltroViewModel filtro)
        {
            var query = _context.Activos
                .Include(a => a.TipoActivo)
                .Include(a => a.Departamento)
                .Include(a => a.Status)
                .Include(a => a.Proveedor)
                .AsQueryable();

            // Filtro por ID
            if (filtro.IdActivo.HasValue)
            {
                query = query.Where(a => a.IdActivo == filtro.IdActivo.Value);
            }

            // Filtro por código (contiene)
            if (!string.IsNullOrEmpty(filtro.CodigoLike))
            {
                query = query.Where(a => a.Codigo.Contains(filtro.CodigoLike));
            }

            // Filtro por marca (contiene)
            if (!string.IsNullOrEmpty(filtro.MarcaLike))
            {
                query = query.Where(a => a.Marca != null && a.Marca.Contains(filtro.MarcaLike));
            }

            // Filtro por nombre (contiene)
            if (!string.IsNullOrEmpty(filtro.NombreLike))
            {
                query = query.Where(a => a.Nombre.Contains(filtro.NombreLike));
            }

            // Filtro por persona asignada (contiene)
            if (!string.IsNullOrEmpty(filtro.PersonaAsignLike))
            {
                query = query.Where(a => a.PersonaAsign != null && a.PersonaAsign.Contains(filtro.PersonaAsignLike));
            }

            // Filtro por ubicación (contiene)
            if (!string.IsNullOrEmpty(filtro.UbicacionLike))
            {
                query = query.Where(a => a.Ubicacion != null && a.Ubicacion.Contains(filtro.UbicacionLike));
            }

            // Filtro por tipo de activo
            if (filtro.TipoActivoId.HasValue)
            {
                query = query.Where(a => a.IdTipoActivo == filtro.TipoActivoId.Value);
            }

            // Filtro por departamento
            if (filtro.DepartamentoId.HasValue)
            {
                query = query.Where(a => a.IdDepartamento == filtro.DepartamentoId.Value);
            }

            // Filtro por status
            if (filtro.StatusId.HasValue)
            {
                query = query.Where(a => a.IdStatus == filtro.StatusId.Value);
            }

            // Filtro por proveedor
            if (filtro.ProveedorId.HasValue)
            {
                query = query.Where(a => a.IdProveedor == filtro.ProveedorId.Value);
            }

            // Filtro por sistema operativo
            if (filtro.TieneSoftwareOP.HasValue)
            {
                query = query.Where(a => a.TieneSoftwareOP == filtro.TieneSoftwareOP.Value);
            }

            // Filtro por rango de costo
            if (filtro.CostoMin.HasValue)
            {
                query = query.Where(a => a.CostoCompra >= filtro.CostoMin.Value);
            }

            if (filtro.CostoMax.HasValue)
            {
                query = query.Where(a => a.CostoCompra <= filtro.CostoMax.Value);
            }

            // Filtros de fecha según el tipo seleccionado
            if (filtro.FechaTarget != ActivoFiltroViewModel.DateTarget.None)
            {
                switch (filtro.FechaTarget)
                {
                    case ActivoFiltroViewModel.DateTarget.FechaAlta:
                        if (filtro.FechaAltaDesde.HasValue)
                            query = query.Where(a => a.FeAlta >= filtro.FechaAltaDesde.Value);
                        if (filtro.FechaAltaHasta.HasValue)
                            query = query.Where(a => a.FeAlta <= filtro.FechaAltaHasta.Value);
                        break;
                    case ActivoFiltroViewModel.DateTarget.FechaCompra:
                        if (filtro.FechaCompraDesde.HasValue)
                            query = query.Where(a => a.FeCompra >= filtro.FechaCompraDesde.Value);
                        if (filtro.FechaCompraHasta.HasValue)
                            query = query.Where(a => a.FeCompra <= filtro.FechaCompraHasta.Value);
                        break;
                    case ActivoFiltroViewModel.DateTarget.FechaBaja:
                        if (filtro.FechaBajaDesde.HasValue)
                            query = query.Where(a => a.FeBaja >= filtro.FechaBajaDesde.Value);
                        if (filtro.FechaBajaHasta.HasValue)
                            query = query.Where(a => a.FeBaja <= filtro.FechaBajaHasta.Value);
                        break;
                }
            }

            // Filtro por componentes (usando operaciones bit a bit)
            if (filtro.ComponentesSeleccionados.Any())
            {
                var componentesMask = filtro.ComponentesSeleccionados.Sum();
                query = query.Where(a => (a.CodificacionComponentes & (CodificacionComponentes)componentesMask) != 0);
            }

            return await query.ToListAsync();
        }
    }
}
