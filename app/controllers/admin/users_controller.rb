class Admin::UsersController < Admin::BaseController
  def index
    @users = User.includes(:role).order(:name)
  end

  def show
    @user = User.find(params[:id])
  end
end
