class Admin::ProvidersController < Admin::BaseController
  before_action :set_provider, only: [:show, :edit, :update, :destroy]

  def index
    @providers = Provider.order(:name)
  end

  def show
  end

  def new
    @provider = Provider.new
  end

  def edit
  end

  def create
    @provider = Provider.new(provider_params)

    if @provider.save
      redirect_to admin_providers_path, notice: "✅ Proveedor creado correctamente"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @provider.update(provider_params)
      redirect_to admin_providers_path, notice: "✅ Proveedor actualizado correctamente"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @provider.products.any?
      redirect_to admin_providers_path(delete_error: "provider", name: @provider.name)
    else
      @provider.destroy
      redirect_to admin_providers_path, notice: "Proveedor eliminado"
    end
  end

  private

  def set_provider
    @provider = Provider.find(params[:id])
  end

  def provider_params
    params.require(:provider).permit(:name, :contact_email)
  end
end
