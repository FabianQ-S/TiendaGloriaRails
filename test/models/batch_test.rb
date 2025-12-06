require "test_helper"

class BatchTest < ActiveSupport::TestCase
  # ============================================
  # Tests para expired?
  # ============================================

  test "expired? retorna true cuando fecha de vencimiento es pasada" do
    batch = Batch.new(expiration_date: Date.current - 1.day)
    assert batch.expired?
  end

  test "expired? retorna false cuando fecha de vencimiento es futura" do
    batch = Batch.new(expiration_date: Date.current + 30.days)
    assert_not batch.expired?
  end

  test "expired? retorna false cuando fecha de vencimiento es hoy" do
    batch = Batch.new(expiration_date: Date.current)
    assert_not batch.expired?
  end

  # ============================================
  # Tests para expiring_soon?
  # ============================================

  test "expiring_soon? retorna true cuando vence en menos de 7 días" do
    batch = Batch.new(expiration_date: Date.current + 5.days)
    assert batch.expiring_soon?
  end

  test "expiring_soon? retorna false cuando vence en más de 7 días" do
    batch = Batch.new(expiration_date: Date.current + 30.days)
    assert_not batch.expiring_soon?
  end

  # ============================================
  # Tests para validaciones
  # ============================================

  test "batch requiere número de lote" do
    batch = Batch.new(batch_number: nil)
    batch.valid?
    assert_includes batch.errors[:batch_number], "El número de lote es obligatorio"
  end

  test "batch requiere fecha de vencimiento" do
    batch = Batch.new(expiration_date: nil)
    batch.valid?
    assert_includes batch.errors[:expiration_date], "La fecha de vencimiento es obligatoria"
  end

  test "número de lote debe ser único" do
    # Crear un lote primero
    Batch.create!(batch_number: "LOTE-UNICO", expiration_date: Date.current + 30.days, quantity: 10)
    
    # Intentar crear otro con el mismo número
    batch = Batch.new(batch_number: "LOTE-UNICO", expiration_date: Date.current + 30.days)
    batch.valid?
    assert_includes batch.errors[:batch_number], "Este número de lote ya existe"
  end
end
