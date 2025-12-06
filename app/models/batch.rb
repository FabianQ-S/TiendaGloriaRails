class Batch < ApplicationRecord
  has_many :products, dependent: :nullify

  validates :batch_number, presence: { message: "El número de lote es obligatorio" },
                          uniqueness: { case_sensitive: false, message: "Este número de lote ya existe" }
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :expiration_date, presence: { message: "La fecha de vencimiento es obligatoria" }

  # Verificar si está vencido
  def expired?
    expiration_date && expiration_date < Date.current
  end

  # Verificar si está por vencer (7 días)
  def expiring_soon?
    expiration_date && !expired? && expiration_date < Date.current + 7.days
  end
end
