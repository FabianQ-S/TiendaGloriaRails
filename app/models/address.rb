class Address < ApplicationRecord
  belongs_to :user
  has_many :orders

  validates :name, presence: { message: "El nombre de la dirección es obligatorio" }
  validates :street, presence: { message: "La calle es obligatoria" }
  validates :city, presence: { message: "La ciudad es obligatoria" }
end
