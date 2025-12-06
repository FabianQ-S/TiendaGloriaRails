class Batch < ApplicationRecord
  belongs_to :product

  validates :batch_number, presence: { message: "El número de lote es obligatorio" }
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :expiration_date, presence: { message: "La fecha de vencimiento es obligatoria" }
end
