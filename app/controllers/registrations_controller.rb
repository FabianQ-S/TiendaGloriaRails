class RegistrationsController < ApplicationController
  def new
    redirect_to root_path, notice: "Ya has iniciado sesión" if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    # Asignar rol de Cliente por defecto
    client_role = Role.find_by(name: "Cliente")
    @user.role = client_role
    @user.active = true

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "¡Bienvenido a Gloria Lácteos! 🥛"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
