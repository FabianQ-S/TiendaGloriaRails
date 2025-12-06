class User < ApplicationRecord
  belongs_to :role
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_secure_password

  # Validaciones
  validates :name, presence: { message: "El nombre es obligatorio" }
  validates :email, presence: { message: "El email es obligatorio" },
                    uniqueness: { case_sensitive: false, message: "Este email ya está registrado" },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "Formato de email inválido" }
  validates :password, length: { minimum: 6, message: "La contraseña debe tener al menos 6 caracteres" }, if: -> { new_record? || password.present? }

  # Verificar si es admin
  def admin?
    role&.name == "Admin"
  end

  # Verificar si está activo
  def active?
    active == true
  end
end
