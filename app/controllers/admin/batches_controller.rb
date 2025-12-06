class Admin::BatchesController < Admin::BaseController
  before_action :set_batch, only: [:show, :edit, :update, :destroy]

  def index
    @batches = Batch.order(expiration_date: :asc)
  end

  def show
  end

  def new
    @batch = Batch.new
  end

  def edit
  end

  def create
    @batch = Batch.new(batch_params)

    if @batch.save
      redirect_to admin_batches_path, notice: "✅ Lote creado correctamente"
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
    if @batch.products.any?
      if @batch.expired?
        # Lote vencido con productos - pedir confirmación
        if params[:confirm_expired] == "1"
          products_count = @batch.products.count
          @batch.products.destroy_all
          @batch.destroy
          redirect_to admin_batches_path, notice: "Lote vencido y #{products_count} productos eliminados"
        else
          redirect_to admin_batches_path(delete_error: "batch_expired_with_products", name: @batch.batch_number, batch_id: @batch.id, count: @batch.products.count)
        end
      else
        # Lote vigente con productos - no permitir
        redirect_to admin_batches_path(delete_error: "batch_with_products", name: @batch.batch_number, count: @batch.products.count)
      end
    else
      @batch.destroy
      redirect_to admin_batches_path, notice: "Lote eliminado"
    end
  end

  private

  def set_batch
    @batch = Batch.find(params[:id])
  end

  def batch_params
    params.require(:batch).permit(:batch_number, :expiration_date, :quantity)
  end
end
