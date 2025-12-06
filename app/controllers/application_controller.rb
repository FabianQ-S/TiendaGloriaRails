class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # Hacer disponibles los helpers en las vistas
  helper_method :current_user, :logged_in?, :admin?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def admin?
    logged_in? && current_user.role&.name == "Admin"
  end

  def require_login
    unless logged_in?
      flash[:alert] = "Debes iniciar sesión para continuar"
      redirect_to login_path
    end
  end

  def require_admin
    unless admin?
      flash[:alert] = "No tienes permisos para acceder a esta sección"
      redirect_to root_path
    end
  end

  # Inicializar carrito
  def cart
    session[:cart] ||= {}
  end
  helper_method :cart

  def cart_count
    cart.values.sum
  end
  helper_method :cart_count
end

