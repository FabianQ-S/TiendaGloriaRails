class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.includes(:category, :provider).order(:name)
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
      # Create initial batch if batch data was provided
      if batch_params[:batch_number].present?
        @product.batches.create(batch_params)
      end
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
    # Check if product has batches
    if @product.batches.any?
      # Check if ALL batches are expired
      active_batches = @product.batches.where("expiration_date >= ?", Date.current)
      
      if active_batches.any?
        # Has active (non-expired) batches - cannot delete
        redirect_to admin_products_path(delete_error: "product_active_batches", name: @product.name, count: active_batches.count)
      else
        # All batches are expired - can delete with confirmation
        if params[:confirm_expired] == "1"
          @product.destroy
          redirect_to admin_products_path, notice: "Producto y #{@product.batches.count} lotes vencidos eliminados"
        else
          redirect_to admin_products_path(delete_error: "product_expired_batches", name: @product.name, product_id: @product.id, count: @product.batches.count)
        end
      end
    else
      # No batches - can delete freely
      @product.destroy
      redirect_to admin_products_path, notice: "Producto eliminado"
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:sku, :name, :description, :price, :image_url, :category_id, :provider_id, :is_perishable, :image)
  end

  def batch_params
    p = params.require(:product).permit(:batch_number, :batch_quantity, :batch_expiration_date)
    {
      batch_number: p[:batch_number],
      quantity: p[:batch_quantity],
      expiration_date: p[:batch_expiration_date]
    }
  end
end

