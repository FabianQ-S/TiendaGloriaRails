# 🥛 Gloria Lácteos - E-commerce

![Ruby on Rails](https://img.shields.io/badge/Rails-8.1-red)
![SQLite](https://img.shields.io/badge/SQLite-3-blue)
![Version](https://img.shields.io/badge/version-1.0.1-green)

E-commerce de productos lácteos Gloria construido con Ruby on Rails.

## 🚀 Inicio Rápido

```bash
# Clonar repositorio
git clone https://github.com/FabianQ-S/TiendaGloriaRails.git
cd TiendaGloriaRails

# Instalar dependencias
bundle install

# Crear base de datos y sembrar datos
bin/rails db:setup

# Iniciar servidor
bin/rails server
```

**URL:** http://localhost:3000

## 🔑 Credenciales de Prueba

| Rol | Email | Contraseña |
|-----|-------|------------|
| Admin | admin@gloria.com | admin123 |
| Cliente | cliente@test.com | cliente123 |

## ✨ Características

### Tienda (Frontend)
- 📦 Catálogo de productos con imágenes
- 🛒 Carrito de compras persistente
- ❌ Productos agotados en gris
- ⚠️ Productos con lote vencido marcados
- 🎉 Checkout con creación de órdenes

### Panel Admin (`/admin`)
- 📊 Dashboard de administración
- 📦 CRUD: Productos, Categorías, Proveedores, Lotes
- 📋 Gestión de órdenes con estados:
  - ⏳ Pendiente (gris)
  - 🚚 Enviado (verde)
  - ✅ Entregado (azul)
- 📈 Control de stock

## 🧪 Pruebas

```bash
# Ejecutar todas las pruebas
bin/rails test

# Solo modelos
bin/rails test test/models
```

## 📚 Documentación

- [Guía de Usuario](docs/GUIA_USUARIO.md)
- [Guía para Desarrolladores](docs/GUIA_DEVELOPER.md)
- [Pruebas Unitarias](docs/PRUEBAS_UNITARIAS.md)
- [Esquema de BD](docs/database_schema.dbml)

## 🛠️ Stack Tecnológico

- **Framework:** Ruby on Rails 8.1
- **Base de datos:** SQLite
- **Frontend:** Turbo Rails
- **Imágenes:** Active Storage
- **Autenticación:** bcrypt (has_secure_password)

## 📝 Licencia

MIT License - Proyecto educativo
