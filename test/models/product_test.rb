require "test_helper"

class ProductTest < ActiveSupport::TestCase
  # ============================================
  # Tests para el método out_of_stock?
  # ============================================
  
  test "out_of_stock? retorna true cuando stock es 0" do
    product = Product.new(stock: 0)
    assert product.out_of_stock?
  end

  test "out_of_stock? retorna false cuando stock es mayor a 0" do
    product = Product.new(stock: 10)
    assert_not product.out_of_stock?
  end

  test "out_of_stock? retorna true cuando stock es negativo" do
    product = Product.new(stock: -1)
    assert product.out_of_stock?
  end

  # ============================================
  # Tests para validaciones
  # ============================================

  test "producto requiere nombre" do
    product = Product.new(name: nil)
    product.valid?
    assert_includes product.errors[:name], "El nombre es obligatorio"
  end

  test "producto requiere SKU" do
    product = Product.new(sku: nil)
    product.valid?
    assert_includes product.errors[:sku], "El SKU es obligatorio"
  end

  test "producto requiere precio mayor a 0" do
    product = Product.new(price: 0)
    product.valid?
    assert_includes product.errors[:price], "El precio debe ser mayor a 0"
  end

  test "stock no puede ser negativo" do
    product = Product.new(stock: -5)
    product.valid?
    assert_includes product.errors[:stock], "El stock no puede ser negativo"
  end

  # ============================================
  # Tests para unavailable_for_sale?
  # ============================================

  test "unavailable_for_sale? retorna true cuando stock es 0" do
    product = Product.new(stock: 0)
    assert product.unavailable_for_sale?
  end

  test "unavailable_for_sale? retorna false cuando hay stock y no hay lote vencido" do
    product = Product.new(stock: 10)
    product.batch = nil
    assert_not product.unavailable_for_sale?
  end
end
