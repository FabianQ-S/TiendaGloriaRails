class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: [:show, :update]

  def index
    @orders = Order.includes(:user, :order_items).order(created_at: :desc)
  end

  def show
  end

  def update
    if @order.update(order_params)
      redirect_to admin_orders_path, notice: "✅ Estado de orden actualizado"
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end
end
