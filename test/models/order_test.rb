require "test_helper"

class OrderTest < ActiveSupport::TestCase
  # ============================================
  # Tests para generación automática de número
  # ============================================

  test "genera número de orden automáticamente al crear" do
    user = User.first || User.create!(
      name: "Test User",
      email: "test@test.com",
      password: "password123",
      role: Role.first || Role.create!(name: "Cliente")
    )
    
    order = Order.new(user: user, status: 'pendiente')
    order.save
    
    assert order.order_number.present?
    assert order.order_number.start_with?("ORD-")
  end

  # ============================================
  # Tests para estados
  # ============================================

  test "status pendiente es válido" do
    order = Order.new(status: 'pendiente')
    order.valid?
    assert_not_includes order.errors[:status], "Estado inválido"
  end

  test "status enviado es válido" do
    order = Order.new(status: 'enviado')
    order.valid?
    assert_not_includes order.errors[:status], "Estado inválido"
  end

  test "status entregado es válido" do
    order = Order.new(status: 'entregado')
    order.valid?
    assert_not_includes order.errors[:status], "Estado inválido"
  end

  test "status inválido genera error" do
    order = Order.new(status: 'estado_falso')
    order.valid?
    assert_includes order.errors[:status], "Estado inválido"
  end

  # ============================================
  # Tests para helpers de estado
  # ============================================

  test "status_label retorna etiqueta correcta para pendiente" do
    order = Order.new(status: 'pendiente')
    assert_equal 'Pendiente', order.status_label
  end

  test "status_label retorna etiqueta correcta para enviado" do
    order = Order.new(status: 'enviado')
    assert_equal 'Enviado', order.status_label
  end

  test "status_label retorna etiqueta correcta para entregado" do
    order = Order.new(status: 'entregado')
    assert_equal 'Entregado', order.status_label
  end

  test "status_icon retorna icono correcto para pendiente" do
    order = Order.new(status: 'pendiente')
    assert_equal '⏳', order.status_icon
  end

  test "status_icon retorna icono correcto para enviado" do
    order = Order.new(status: 'enviado')
    assert_equal '🚚', order.status_icon
  end

  test "status_icon retorna icono correcto para entregado" do
    order = Order.new(status: 'entregado')
    assert_equal '✅', order.status_icon
  end
end
