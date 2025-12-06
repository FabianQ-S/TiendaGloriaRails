# 🥛 Gloria Lácteos - Guía de Usuario

Sistema de E-commerce para productos lácteos Gloria, desarrollado en Ruby on Rails.

---

## 📋 Índice

1. [Requisitos](#requisitos)
2. [Instalación](#instalación)
3. [Credenciales de Acceso](#credenciales-de-acceso)
4. [Funcionalidades](#funcionalidades)
5. [Guía de Uso](#guía-de-uso)

---

## Requisitos

- Ruby 3.2+
- Rails 8.1+
- SQLite3
- Node.js (para asset pipeline)

---

## Instalación

```bash
# 1. Clonar el repositorio
git clone <url-del-repositorio>
cd TiendaGloriaRails

# 2. Instalar dependencias
bundle install

# 3. Configurar base de datos
rails db:create
rails db:migrate

# 4. Cargar datos de prueba (IMPORTANTE)
rails db:seed

# 5. Iniciar el servidor
rails server
```

Luego visita: [http://localhost:3000](http://localhost:3000)

---

## Credenciales de Acceso

### Administrador
- **Email:** `admin@gloria.com`
- **Contraseña:** `admin123`

### Cliente de Prueba
- **Email:** `cliente@test.com`
- **Contraseña:** `cliente123`

---

## Funcionalidades

### 🏠 Tienda (Público)
- Ver catálogo de productos lácteos
- Buscar productos por nombre
- Filtrar por categoría
- Ver detalles de productos

### 🛒 Carrito de Compras
- Agregar productos al carrito (requiere login)
- Ver productos en el carrito
- Eliminar productos del carrito
- Simular compra (checkout)

### 👤 Perfil de Usuario
- Editar nombre
- Cambiar contraseña
- Ver y gestionar direcciones

### ⚙️ Panel de Administración
Acceso exclusivo para usuarios con rol "Admin":

- **Dashboard:** Estadísticas generales y órdenes recientes
- **Productos:** CRUD completo + subida de imágenes
- **Categorías:** Gestión de categorías y subcategorías
- **Proveedores:** Gestión de proveedores
- **Lotes:** Control de lotes y fechas de vencimiento
- **Órdenes:** Ver y actualizar estado de órdenes
- **Usuarios:** Ver usuarios (solo lectura)
- **Roles:** Gestión de roles

---

## Guía de Uso

### Para Clientes

1. **Registrarse:** 
   - Click en "📝 Registrarse" en el menú
   - Completar el formulario con nombre, email y contraseña
   - La cuenta se crea automáticamente con rol "Cliente"

2. **Comprar Productos:**
   - Navegar por la tienda o buscar productos
   - Click en "🛒 Agregar al carrito" (requiere estar logueado)
   - Ir al carrito para revisar productos
   - Click en "🎉 Comprar ahora" para finalizar

3. **Editar Perfil:**
   - Click en tu nombre en el menú
   - Modificar nombre o cambiar contraseña
   - Guardar cambios

### Para Administradores

1. **Acceder al Panel Admin:**
   - Iniciar sesión como admin
   - Click en "⚙️ Admin" en el menú
   
2. **Gestionar Productos:**
   - Ir a "📦 Productos" en el sidebar
   - Crear nuevos productos con "➕ Nuevo Producto"
   - Subir imágenes desde el formulario de edición
   - Asociar categoría y proveedor

3. **Gestionar Categorías:**
   - Ir a "🏷️ Categorías"
   - Crear categorías padre/hijo para organizar productos

4. **Control de Lotes:**
   - Ir a "📋 Lotes"
   - Agregar lotes con fecha de vencimiento
   - El sistema muestra alertas para productos próximos a vencer

5. **Ver Órdenes:**
   - Ir a "🧾 Órdenes"
   - Actualizar estado de las órdenes (pendiente → pagado → enviado → entregado)

6. **Ver Usuarios:**
   - Ir a "👥 Usuarios"
   - Ver información de usuarios registrados
   - *Nota: No se pueden editar las credenciales de usuarios*

---

## Estructura del Proyecto

```
app/
├── controllers/
│   ├── admin/           # Controladores del panel admin
│   ├── sessions_controller.rb
│   ├── registrations_controller.rb
│   ├── store_controller.rb
│   ├── carts_controller.rb
│   └── profile_controller.rb
├── models/
│   ├── user.rb          # Con has_secure_password
│   ├── product.rb       # Con Active Storage
│   └── ...
├── views/
│   ├── admin/           # Vistas del panel admin
│   ├── layouts/
│   │   ├── application.html.erb
│   │   └── admin.html.erb
│   └── ...
└── assets/
    └── stylesheets/
        └── application.css  # Estilos Gloria (azul/blanco)
```

---

## Colores de Marca

- **Azul Claro:** `#5DADE2`
- **Azul Oscuro:** `#1A5276`
- **Blanco:** `#FFFFFF`

---

## Comandos Útiles

```bash
# Iniciar servidor
rails server

# Consola de Rails
rails console

# Recargar seeds (borra datos existentes)
rails db:seed:replant

# Ver rutas
rails routes
```

---

## Notas Técnicas

- **Autenticación:** Implementada con `has_secure_password` (bcrypt)
- **Carrito:** Basado en sesión (no requiere BD)
- **Imágenes:** Usando Active Storage
- **Estilos:** CSS puro con variables CSS
- **JavaScript:** Turbo y Stimulus (Hotwire)

---

*Gloria Lácteos © 2024 - Productos lácteos de calidad*
