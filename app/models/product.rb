class Product < ApplicationRecord
  belongs_to :category
  belongs_to :provider
  has_many :batches, dependent: :destroy
  has_many :order_items

  # Active Storage para imágenes
  has_one_attached :image

  # Validaciones
  validates :name, presence: { message: "El nombre es obligatorio" }
  validates :sku, presence: { message: "El SKU es obligatorio" },
                  uniqueness: { case_sensitive: false, message: "Este SKU ya existe" }
  validates :price, presence: { message: "El precio es obligatorio" },
                    numericality: { greater_than: 0, message: "El precio debe ser mayor a 0" }

  # Lógica del stock total (suma de lotes)
  def total_stock
    batches.sum(:quantity)
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
