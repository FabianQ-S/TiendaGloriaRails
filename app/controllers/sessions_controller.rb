class SessionsController < ApplicationController
  def new
    redirect_to root_path, notice: "Ya has iniciado sesión" if logged_in?
  end

  def create
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
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
    session[:user_id] = nil
    session[:cart] = nil
    redirect_to root_path, notice: "Sesión cerrada correctamente"
  end
end
