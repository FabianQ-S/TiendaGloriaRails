class SessionsController < ApplicationController
  def new
    redirect_to root_path, notice: "Ya has iniciado sesión" if logged_in?
  end

  def create
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        
        # Cargar carrito guardado en la base de datos a la sesión
        load_cart_from_database(user)
        
        if user.admin?
          redirect_to admin_dashboard_path, notice: "¡Bienvenido, #{user.name}! 🥛"
        else
          redirect_to root_path, notice: "¡Bienvenido, #{user.name}! 🥛"
        end
      else
        flash.now[:alert] = "Tu cuenta está desactivada"
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Email o contraseña incorrectos"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # Guardar carrito de la sesión a la base de datos antes de cerrar sesión
    save_cart_to_database(current_user) if logged_in?
    
    session[:user_id] = nil
    session[:cart] = nil
    redirect_to root_path, notice: "Sesión cerrada correctamente"
  end

  private

  # Guarda el carrito de la sesión a la base de datos
  def save_cart_to_database(user)
    return unless user && session[:cart].present?
    
    session[:cart].each do |product_id, quantity|
      cart_item = user.cart_items.find_or_initialize_by(product_id: product_id)
      cart_item.quantity = quantity
      cart_item.save
    end
  end

  # Carga el carrito de la base de datos a la sesión
  def load_cart_from_database(user)
    return unless user
    
    # Inicializar carrito vacío si no existe en sesión
    session[:cart] ||= {}
    
    # Cargar items guardados del usuario
    user.cart_items.each do |item|
      session[:cart][item.product_id.to_s] = item.quantity
    end
  end
end

