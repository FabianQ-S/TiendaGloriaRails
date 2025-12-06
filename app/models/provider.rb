class Provider < ApplicationRecord
  has_many :products, dependent: :nullify

  validates :name, presence: { message: "El nombre es obligatorio" }
  validates :contact_email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Formato de email inválido" }, allow_blank: true
end
