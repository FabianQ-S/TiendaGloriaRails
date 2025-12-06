# 🛠️ Gloria Lácteos - Guía para Desarrolladores

## Descripción del Proyecto

Gloria Lácteos es un e-commerce de productos lácteos construido con **Ruby on Rails 8.1** y **SQLite**. El proyecto sigue las convenciones de Rails y está diseñado para ser simple de entender y extender.

---

## 🚀 Inicio Rápido

```bash
# Clonar repositorio
git clone <repo-url>
cd TiendaGloriaRails

# Instalar dependencias
bundle install

# Crear base de datos y sembrar datos
bin/rails db:setup

# Iniciar servidor
bin/rails server
```

**URL:** http://localhost:3000

---

## 🔑 Credenciales de Prueba

| Rol | Email | Contraseña |
|-----|-------|------------|
| Admin | admin@gloria.com | admin123 |
| Cliente | cliente@test.com | cliente123 |

---

## 📁 Estructura del Proyecto

```
app/
├── controllers/
│   ├── admin/              # Panel de administración
│   │   ├── base_controller.rb
│   │   ├── products_controller.rb
│   │   ├── categories_controller.rb
│   │   ├── providers_controller.rb
│   │   └── batches_controller.rb
│   ├── sessions_controller.rb     # Login/logout
│   ├── registrations_controller.rb # Registro
│   ├── carts_controller.rb        # Carrito de compras
│   ├── store_controller.rb        # Tienda pública
│   └── profile_controller.rb      # Perfil de usuario
├── models/
│   ├── user.rb            # has_many :cart_items, :orders
│   ├── product.rb         # belongs_to :batch (opcional), :category, :provider
│   ├── batch.rb           # has_many :products
│   ├── category.rb        # has_many :products
│   ├── provider.rb        # has_many :products
│   ├── cart_item.rb       # Carrito persistente
│   └── order.rb / order_item.rb
└── views/
    ├── layouts/
    │   ├── application.html.erb  # Layout tienda
    │   └── admin.html.erb        # Layout admin
    ├── store/                    # Vista de tienda
    ├── carts/                    # Vista del carrito
    └── admin/                    # Vistas del admin
```

---

## 🗄️ Modelos y Relaciones

### Product
```ruby
belongs_to :category
belongs_to :provider
belongs_to :batch, optional: true  # Puede no tener lote
has_many :order_items

# Campos importantes
# - stock: integer (0 = agotado)
# - batch_id: integer (si el lote está vencido, producto no disponible)

# Métodos clave
def out_of_stock?           # stock <= 0
def batch_expired?          # batch&.expired?
def unavailable_for_sale?   # agotado O lote vencido
```

### Batch
```ruby
has_many :products

# Campos
# - batch_number: string (único)
# - quantity: integer
# - expiration_date: date

# Métodos
def expired?        # expiration_date < Date.current
def expiring_soon?  # vence en menos de 7 días
```

### CartItem (Carrito Persistente)
```ruby
belongs_to :user
belongs_to :product

# Se guarda al hacer logout
# Se carga al hacer login
```

---

## 🔐 Autenticación

- Usa `has_secure_password` (bcrypt)
- Sesiones almacenadas en cookies
- Helper methods en `ApplicationController`:
  - `current_user`
  - `logged_in?`
  - `admin?`

---

## 🛒 Flujo del Carrito

1. **Agregar producto** → `CartsController#add`
2. **Ver carrito** → `CartsController#show`
3. **Modificar cantidad** → `CartsController#update_quantity` (➕➖)
4. **Checkout** → `CartsController#checkout`
   - Valida stock disponible
   - Reduce stock de cada producto
   - Limpia carrito (sesión + BD)
   - Muestra popup de confirmación

### Carrito Persistente
- Al **logout**: `save_cart_to_database(user)`
- Al **login**: `load_cart_from_database(user)`

---

## 🛡️ Validaciones Importantes

### Eliminación de Lotes
- **Con productos + vigente** → ❌ No permite
- **Con productos + vencido** → ⚠️ Pide confirmación, elimina lote y productos

### Eliminación de Proveedores/Categorías
- **Con productos** → ❌ No permite (popup de error)

### Productos no disponibles para venta
- Stock = 0 → Agotado
- Lote vencido → Vencido
- Ambos muestran tarjeta gris en tienda

---

## 📊 Panel de Administración

**URL:** `/admin`

### Funcionalidades
- Dashboard con estadísticas
- CRUD Productos (con selector de lote y stock)
- CRUD Categorías
- CRUD Proveedores  
- CRUD Lotes
- Ver Usuarios
- Ver Órdenes

---

## 🎨 Assets

- **CSS:** `app/assets/stylesheets/application.css`
- **Logo:** `app/assets/images/logo_gloria.webp`
- **Imágenes:** Active Storage

---

## 🔮 Ideas para Futuras Mejoras

1. **Direcciones de entrega** - Ya existe el modelo, falta UI
2. **Órdenes reales** - Actualmente es simulación
3. **Pasarela de pago** - Integrar con Stripe/PayPal
4. **Notificaciones** - Email al comprar
5. **Reportes** - Ventas, productos más vendidos
6. **API REST** - Para app móvil
7. **Búsqueda avanzada** - Filtros por precio, proveedor
8. **Wishlist** - Lista de deseos

---

## 📚 Documentación Adicional

- [database_schema.dbml](./database_schema.dbml) - Diagrama de base de datos
- [GUIA_USUARIO.md](./GUIA_USUARIO.md) - Manual para usuarios finales

---

## 🤝 Contribuir

1. Fork del repositorio
2. Crear rama: `git checkout -b feature/nueva-funcionalidad`
3. Hacer cambios y commit
4. Push y crear Pull Request

---

**Ruby on Rails 8.1 | SQLite | Turbo | Active Storage**
