class Product < ApplicationRecord
  belongs_to :category
  belongs_to :provider
  belongs_to :batch, optional: true
  has_many :order_items, dependent: :destroy
  has_many :cart_items, dependent: :destroy

  # Active Storage para imágenes
  has_one_attached :image

  # Validaciones
  validates :name, presence: { message: "El nombre es obligatorio" }
  validates :sku, presence: { message: "El SKU es obligatorio" },
                  uniqueness: { case_sensitive: false, message: "Este SKU ya existe" }
  validates :price, presence: { message: "El precio es obligatorio" },
                    numericality: { greater_than: 0, message: "El precio debe ser mayor a 0" }
  validates :stock, numericality: { greater_than_or_equal_to: 0, message: "El stock no puede ser negativo" }

  # Verificar si está agotado (sin stock)
  def out_of_stock?
    stock <= 0
  end

  # Verificar si el lote está vencido
  def batch_expired?
    batch&.expired?
  end

  # No disponible para venta (agotado O lote vencido)
  def unavailable_for_sale?
    out_of_stock? || batch_expired?
  end

  # URL de imagen o placeholder
  def image_url_or_placeholder
    if image.attached?
      image
    elsif image_url.present?
      image_url
    else
      nil
    end
  end
end

