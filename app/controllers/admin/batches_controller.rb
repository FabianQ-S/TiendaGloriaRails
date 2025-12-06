class Admin::BatchesController < Admin::BaseController
  before_action :set_batch, only: [:show, :edit, :update, :destroy]

  def index
    @batches = Batch.includes(:product).order(expiration_date: :asc)
  end

  def show
  end

  def new
    @batch = Batch.new
    # Pre-select product if coming from product page
    @batch.product_id = params[:product_id] if params[:product_id].present?
  end

  def edit
  end

  def create
    @batch = Batch.new(batch_params)

    if @batch.save
      # Redirect to product page if came from there
      if params[:batch][:return_to_product] == "1"
        redirect_to admin_product_path(@batch.product), notice: "✅ Lote creado correctamente"
      else
        redirect_to admin_batches_path, notice: "✅ Lote creado correctamente"
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @batch.update(batch_params)
      redirect_to admin_batches_path, notice: "✅ Lote actualizado correctamente"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @batch.destroy
    redirect_to admin_batches_path, notice: "Lote eliminado"
  end

  private

  def set_batch
    @batch = Batch.find(params[:id])
  end

  def batch_params
    params.require(:batch).permit(:product_id, :batch_number, :expiration_date, :quantity)
  end
end
