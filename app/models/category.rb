class Category < ApplicationRecord
  # Una categoría puede tener una categoría padre
  belongs_to :parent, class_name: "Category", optional: true

  # Una categoría puede tener muchas subcategorías hijas
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id", dependent: :nullify

  # Productos de esta categoría
  has_many :products, dependent: :nullify

  # Validaciones
  validates :name, presence: { message: "El nombre es obligatorio" }
end
