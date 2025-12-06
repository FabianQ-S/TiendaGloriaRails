class Role < ApplicationRecord
  has_many :users

  validates :name, presence: { message: "El nombre es obligatorio" },
                   uniqueness: { case_sensitive: false, message: "Este rol ya existe" }
end
