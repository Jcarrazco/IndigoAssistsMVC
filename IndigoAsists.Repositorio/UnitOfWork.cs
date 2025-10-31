using Microsoft.EntityFrameworkCore.Storage;
using IndigoAssits.Repositorio.Core.Interfaces;
using IndigoAsists.Repositorio.Db;
using IndigoAsists.Repositorio.Repositories;

namespace IndigoAsists.Repositorio
{
    /// <summary>
    /// Implementación del patrón Unit of Work para manejo de transacciones
    /// </summary>
    public class UnitOfWork : IUnitOfWork
    {
        private readonly IndigoDbContext _context;
        private IDbContextTransaction? _transaction;
        private bool _disposed = false;

        // Repositorios específicos - lazy loading
        private ITicketRepository? _tickets;
        private ICategoriaRepository? _categorias;
        private IUsuarioRepository? _usuarios;
        private IDepartamentoRepository? _departamentos;
        private IEmpleadoRepository? _empleados;
        private IActivoRepository? _activos;

        // Cache de repositorios genéricos
        private readonly Dictionary<Type, object> _repositories = new();

        public UnitOfWork(IndigoDbContext context)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
        }

        #region Propiedades de Repositorios Específicos

        public ITicketRepository Tickets
        {
            get
            {
                _tickets ??= new TicketRepository(_context);
                return _tickets;
            }
        }

        public ICategoriaRepository Categorias
        {
            get
            {
                _categorias ??= new CategoriaRepository(_context);
                return _categorias;
            }
        }

        public IUsuarioRepository Usuarios
        {
            get
            {
                _usuarios ??= new UsuarioRepository(_context, null);
                return _usuarios;
            }
        }

        public IDepartamentoRepository Departamentos
        {
            get
            {
                _departamentos ??= new DepartamentoRepository(_context);
                return _departamentos;
            }
        }

        public IEmpleadoRepository Empleados
        {
            get
            {
                _empleados ??= new EmpleadoRepository(_context);
                return _empleados;
            }
        }

        public IActivoRepository Activos
        {
            get
            {
                _activos ??= new ActivoRepository(_context);
                return _activos;
            }
        }

        #endregion

        #region Repositorio Genérico

        public IGenericRepository<T> Repository<T>() where T : class
        {
            var type = typeof(T);
            
            if (!_repositories.ContainsKey(type))
            {
                _repositories[type] = new GenericRepository<T>(_context);
            }
            
            return (IGenericRepository<T>)_repositories[type];
        }

        #endregion

        #region Operaciones de Transacción

        public async Task<int> SaveChangesAsync()
        {
            return await _context.SaveChangesAsync();
        }

        public async Task BeginTransactionAsync()
        {
            if (_transaction != null)
            {
                throw new InvalidOperationException("Ya existe una transacción activa.");
            }

            _transaction = await _context.Database.BeginTransactionAsync();
        }

        public async Task CommitTransactionAsync()
        {
            if (_transaction == null)
            {
                throw new InvalidOperationException("No hay transacción activa para confirmar.");
            }

            try
            {
                await _context.SaveChangesAsync();
                await _transaction.CommitAsync();
            }
            catch
            {
                await _transaction.RollbackAsync();
                throw;
            }
            finally
            {
                await _transaction.DisposeAsync();
                _transaction = null;
            }
        }

        public async Task RollbackTransactionAsync()
        {
            if (_transaction == null)
            {
                throw new InvalidOperationException("No hay transacción activa para revertir.");
            }

            try
            {
                await _transaction.RollbackAsync();
            }
            finally
            {
                await _transaction.DisposeAsync();
                _transaction = null;
            }
        }

        #endregion

        #region Operaciones de Transacción con Resultado

        public async Task<T> ExecuteInTransactionAsync<T>(Func<Task<T>> operation)
        {
            if (_transaction != null)
            {
                // Si ya hay una transacción activa, ejecutar dentro de ella
                return await operation();
            }

            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                var result = await operation();
                await _context.SaveChangesAsync();
                await transaction.CommitAsync();
                return result;
            }
            catch
            {
                await transaction.RollbackAsync();
                throw;
            }
        }

        public async Task ExecuteInTransactionAsync(Func<Task> operation)
        {
            if (_transaction != null)
            {
                // Si ya hay una transacción activa, ejecutar dentro de ella
                await operation();
                return;
            }

            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                await operation();
                await _context.SaveChangesAsync();
                await transaction.CommitAsync();
            }
            catch
            {
                await transaction.RollbackAsync();
                throw;
            }
        }

        #endregion

        #region IDisposable

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (!_disposed && disposing)
            {
                _transaction?.Dispose();
                _context.Dispose();
                _disposed = true;
            }
        }

        #endregion
    }
}
