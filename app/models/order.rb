class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address, optional: true
  has_many :order_items, dependent: :destroy

  # Validaciones
  validates :order_number, presence: { message: "El número de orden es obligatorio" },
                           uniqueness: { case_sensitive: false, message: "Este número de orden ya existe" }
  validates :status, inclusion: { in: %w[pendiente pagado enviado entregado cancelado],
                                  message: "Estado inválido" }

  # Generar número de orden automático
  before_validation :generate_order_number, on: :create

  # Calcular total
  def calculate_total
    order_items.sum { |item| item.price * item.quantity }
  end

  private

  def generate_order_number
    self.order_number ||= "ORD-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
  end
end
