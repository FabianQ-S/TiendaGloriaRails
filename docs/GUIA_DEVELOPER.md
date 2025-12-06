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
│   │   ├── batches_controller.rb
│   │   └── orders_controller.rb    # Gestión de órdenes
│   ├── sessions_controller.rb
│   ├── registrations_controller.rb
│   ├── carts_controller.rb         # Carrito y checkout
│   ├── store_controller.rb
│   └── profile_controller.rb
├── models/
│   ├── user.rb            # has_many :cart_items, :orders
│   ├── product.rb         # belongs_to :batch, :category, :provider
│   ├── batch.rb           # has_many :products
│   ├── order.rb           # has_many :order_items (3 estados)
│   ├── order_item.rb      # belongs_to :order, :product
│   ├── cart_item.rb       # Carrito persistente
│   └── ...
└── views/
    ├── layouts/
    ├── store/
    ├── carts/
    └── admin/
        └── orders/         # Vista de órdenes
```

---

## 🗄️ Modelos y Relaciones

### Order (Sistema de Órdenes)
```ruby
belongs_to :user
belongs_to :address, optional: true
has_many :order_items, dependent: :destroy

# Estados posibles
STATUSES = {
  'pendiente' => { label: 'Pendiente', color: 'gray', icon: '⏳' },
  'enviado' => { label: 'Enviado', color: 'green', icon: '🚚' },
  'entregado' => { label: 'Entregado', color: 'blue', icon: '✅' }
}

# Methods
def status_label   # Etiqueta legible
def status_color   # Color CSS
def status_icon    # Emoji
```

### Product
```ruby
belongs_to :category
belongs_to :provider
belongs_to :batch, optional: true
has_many :order_items, dependent: :destroy
has_many :cart_items, dependent: :destroy

# Campos
# - stock: integer (0 = agotado)
# - batch_id: integer (lote vencido = no disponible)

# Methods
def out_of_stock?           # stock <= 0
def batch_expired?          # batch&.expired?
def unavailable_for_sale?   # agotado O lote vencido
```

### Batch
```ruby
has_many :products

# Methods
def expired?        # expiration_date < Date.current
def expiring_soon?  # vence en menos de 7 días
```

---

## 🛒 Flujo de Compra (Checkout)

```
1. Cliente agrega productos al carrito
   ↓
2. CartsController#add → session[:cart]
   ↓
3. Cliente hace checkout
   ↓
4. CartsController#checkout:
   - Verifica stock disponible
   - Crea Order (status: 'pendiente')
   - Crea OrderItems para cada producto
   - Reduce stock de productos
   - Limpia carrito (sesión + BD)
   - Redirige con número de orden
   ↓
5. Admin ve orden en /admin/orders
   ↓
6. Admin cambia estado: pendiente → enviado → entregado
```

---

## 📊 Panel de Administración

**URL:** `/admin`

### Órdenes (`/admin/orders`)
- Lista de todas las órdenes con cliente, productos, total
- Estados con colores: ⏳ Pendiente (gris), 🚚 Enviado (verde), ✅ Entregado (azul)
- Botones para cambiar estado rápidamente

### Otras funcionalidades
- CRUD Productos (con stock y lote)
- CRUD Categorías
- CRUD Proveedores
- CRUD Lotes (validación de eliminación)
- Ver Usuarios

---

## 🛡️ Validaciones Importantes

### Eliminación de Lotes
- **Vigente con productos** → ❌ No permite
- **Vencido con productos** → ⚠️ Confirma y elimina lote + productos

### Eliminación de Productos
- Se eliminan también: order_items, cart_items

### Stock y Disponibilidad
- Stock = 0 → Producto agotado
- Lote vencido → Producto no disponible
- Ambos muestran tarjeta gris en tienda

---

## 🎨 Assets

- **CSS:** `app/assets/stylesheets/application.css`
- **Logo:** `app/assets/images/logo_gloria.webp`
- **Imágenes:** Active Storage

---

## 🔮 Ideas para Futuras Mejoras

1. **Direcciones de entrega** - Asignar dirección a la orden
2. **Historial de pedidos** - Vista para clientes
3. **Pasarela de pago** - Integrar Stripe/PayPal
4. **Notificaciones email** - Confirmación de compra
5. **Reportes** - Ventas, productos más vendidos
6. **API REST** - Para app móvil
7. **Búsqueda avanzada** - Filtros por precio
8. **Seguimiento de envío** - Número de tracking

---

## 📚 Documentación

- [database_schema.dbml](./database_schema.dbml) - Diagrama de base de datos
- [GUIA_USUARIO.md](./GUIA_USUARIO.md) - Manual para usuarios

---

## 🤝 Contribuir

1. Fork del repositorio
2. Crear rama: `git checkout -b feature/nueva-funcionalidad`
3. Hacer cambios y commit
4. Push y crear Pull Request

---

**Ruby on Rails 8.1 | SQLite | Turbo | Active Storage**
