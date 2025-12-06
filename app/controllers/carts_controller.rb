class CartsController < ApplicationController
  def show
    @cart_items = get_cart_products
    @total = calculate_total
  end

  def add
    unless logged_in?
      flash[:alert] = "⚠️ Debes iniciar sesión para agregar productos al carrito"
      redirect_to login_path
      return
    end

    product_id = params[:id].to_s
    cart[product_id] ||= 0
    cart[product_id] += 1

    product = Product.find(params[:id])
    flash[:notice] = "✅ #{product.name} agregado al carrito"
    redirect_back(fallback_location: root_path)
  end

  def remove
    product_id = params[:id].to_s
    cart.delete(product_id)
    flash[:notice] = "Producto eliminado del carrito"
    redirect_to cart_path
  end

  def update_quantity
    product_id = params[:id].to_s
    quantity = params[:quantity].to_i

    if quantity <= 0
      cart.delete(product_id)
    else
      cart[product_id] = quantity
    end

    redirect_to cart_path
  end

  def checkout
    unless logged_in?
      flash[:alert] = "Debes iniciar sesión para comprar"
      redirect_to login_path
      return
    end

    if cart.empty?
      flash[:alert] = "Tu carrito está vacío"
      redirect_to cart_path
      return
    end

    # Verificar stock disponible y reducir
    cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      if product
        if product.stock < quantity
          flash[:alert] = "No hay suficiente stock de #{product.name}. Disponible: #{product.stock}"
          redirect_to cart_path
          return
        end
      end
    end

    # Reducir stock de cada producto
    cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      if product
        product.update(stock: product.stock - quantity)
      end
    end

    total = calculate_total
    
    # Limpiar carrito de sesión y base de datos
    session[:cart] = {}
    current_user.cart_items.destroy_all
    
    # Redirigir con parámetro para mostrar popup
    redirect_to root_path(purchased: true, total: total)
  end

  private

  def get_cart_products
    cart.map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product
      { product: product, quantity: quantity, subtotal: product.price * quantity }
    end.compact
  end

  def calculate_total
    get_cart_products.sum { |item| item[:subtotal] }
  end
end
