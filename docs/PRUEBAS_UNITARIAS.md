# 🧪 Guía de Pruebas Unitarias - Gloria Lácteos

## Introducción

Las pruebas unitarias son pruebas **atómicas** que verifican el comportamiento de una unidad individual de código (un método, una clase, etc.) de forma aislada. En Rails usamos **Minitest** (incluido por defecto) o **RSpec**.

Este proyecto usa **Minitest** que viene integrado con Rails.

---

## 📁 Estructura de Pruebas

```
test/
├── controllers/           # Pruebas de controladores
├── fixtures/              # Datos de prueba (YAML)
├── helpers/               # Pruebas de helpers
├── integration/           # Pruebas de integración
├── mailers/               # Pruebas de mailers
├── models/                # Pruebas de modelos ⭐
├── system/                # Pruebas de sistema (con navegador)
├── test_helper.rb         # Configuración base
└── application_system_test_case.rb
```

---

## 🚀 Comandos Básicos

```bash
# Ejecutar TODAS las pruebas
bin/rails test

# Ejecutar solo pruebas de modelos
bin/rails test test/models

# Ejecutar un archivo específico
bin/rails test test/models/product_test.rb

# Ejecutar una prueba específica por línea
bin/rails test test/models/product_test.rb:10

# Ejecutar pruebas con más detalle
bin/rails test -v
```

---

## 📝 Anatomía de una Prueba Unitaria

### Estructura básica

```ruby
# test/models/product_test.rb
require "test_helper"

class ProductTest < ActiveSupport::TestCase
  # Setup: se ejecuta ANTES de cada test
  setup do
    @product = Product.new(
      sku: "TEST-001",
      name: "Producto de Prueba",
      price: 10.00,
      stock: 50,
      category: categories(:leches),
      provider: providers(:gloria)
    )
  end

  # Test individual - nombre descriptivo
  test "producto válido con todos los campos" do
    assert @product.valid?
  end

  test "requiere nombre" do
    @product.name = nil
    assert_not @product.valid?
    assert_includes @product.errors[:name], "El nombre es obligatorio"
  end

  test "out_of_stock? retorna true cuando stock es 0" do
    @product.stock = 0
    assert @product.out_of_stock?
  end

  test "out_of_stock? retorna false cuando stock > 0" do
    @product.stock = 10
    assert_not @product.out_of_stock?
  end
end
```

---

## 🔧 Fixtures (Datos de Prueba)

Los fixtures son datos predefinidos que se cargan en la base de datos de pruebas.

### Ejemplo: `test/fixtures/products.yml`

```yaml
leche_entera:
  sku: "LECHE-001"
  name: "Leche Gloria Entera 1L"
  price: 5.50
  stock: 100
  category: leches
  provider: gloria
  is_perishable: true

producto_agotado:
  sku: "AGOTADO-001"
  name: "Producto Agotado"
  price: 10.00
  stock: 0
  category: leches
  provider: gloria
```

### Usar fixtures en tests:

```ruby
test "producto fixture está agotado" do
  producto = products(:producto_agotado)
  assert producto.out_of_stock?
end
```

---

## ✅ Assertions Comunes

| Assertion | Descripción |
|-----------|-------------|
| `assert x` | x es verdadero |
| `assert_not x` | x es falso |
| `assert_equal(a, b)` | a == b |
| `assert_not_equal(a, b)` | a != b |
| `assert_nil x` | x es nil |
| `assert_not_nil x` | x no es nil |
| `assert_includes(arr, item)` | arr incluye item |
| `assert_empty x` | x está vacío |
| `assert_raises(Error) { }` | el bloque lanza Error |
| `assert_difference('Model.count', n) { }` | la cuenta cambia en n |

---

## 📊 Ejemplo: Prueba de Modelo Order

```ruby
# test/models/order_test.rb
require "test_helper"

class OrderTest < ActiveSupport::TestCase
  setup do
    @user = users(:cliente)
    @order = Order.new(user: @user, status: 'pendiente')
  end

  test "genera número de orden automáticamente" do
    @order.save
    assert @order.order_number.present?
    assert @order.order_number.start_with?("ORD-")
  end

  test "status debe ser válido" do
    @order.status = "invalido"
    assert_not @order.valid?
  end

  test "status_label retorna etiqueta correcta" do
    @order.status = 'enviado'
    assert_equal 'Enviado', @order.status_label
  end
end
```

---

## 🎯 Buenas Prácticas

1. **Una assertion por test** (cuando sea posible)
2. **Nombres descriptivos** - El nombre debe explicar qué se prueba
3. **Independencia** - Cada test debe funcionar solo
4. **Setup compartido** - Usar `setup` para código común
5. **Probar casos límite** - Stock 0, fechas vencidas, etc.
6. **Probar validaciones** - Campos requeridos, formatos

---

## 🔄 Ciclo de Desarrollo con Tests (TDD)

1. **🔴 RED** - Escribir test que falla
2. **🟢 GREEN** - Escribir código mínimo para pasar
3. **🔵 REFACTOR** - Mejorar el código manteniendo tests verdes

---

## 📚 Recursos

- [Rails Testing Guide](https://guides.rubyonrails.org/testing.html)
- [Minitest Documentation](https://github.com/minitest/minitest)
- [Rails Fixtures](https://api.rubyonrails.org/classes/ActiveRecord/FixtureSet.html)
