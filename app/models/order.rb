class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address, optional: true
  has_many :order_items, dependent: :destroy

  # Estados posibles
  STATUSES = {
    'pendiente' => { label: 'Pendiente', color: 'gray', icon: '⏳' },
    'enviado' => { label: 'Enviado', color: 'green', icon: '🚚' },
    'entregado' => { label: 'Entregado', color: 'blue', icon: '✅' }
  }.freeze

  # Validaciones
  validates :order_number, presence: { message: "El número de orden es obligatorio" },
                           uniqueness: { case_sensitive: false, message: "Este número de orden ya existe" }
  validates :status, inclusion: { in: STATUSES.keys, message: "Estado inválido" }

  # Generar número de orden automático
  before_validation :generate_order_number, on: :create
  before_validation :set_default_status, on: :create

  # Scopes
  scope :recent, -> { order(created_at: :desc) }

  # Helpers para estados
  def status_label
    STATUSES.dig(status, :label) || status
  end

  def status_color
    STATUSES.dig(status, :color) || 'gray'
  end

  def status_icon
    STATUSES.dig(status, :icon) || '📦'
  end

  private

  def generate_order_number
    self.order_number ||= "ORD-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
  end

  def set_default_status
    self.status ||= 'pendiente'
  end
end
