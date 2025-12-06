class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.includes(:category, :provider, :batch).order(:name)
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to admin_products_path, notice: "✅ Producto creado correctamente"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      redirect_to admin_products_path, notice: "✅ Producto actualizado correctamente"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      @product.destroy
      redirect_to admin_products_path, notice: "Producto eliminado"
    rescue ActiveRecord::InvalidForeignKey
      redirect_to admin_products_path(delete_error: "product_has_references", name: @product.name)
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:sku, :name, :description, :price, :image_url, :category_id, :provider_id, :is_perishable, :image, :stock, :batch_id)
  end
end
