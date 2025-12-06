class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: [:show, :update_status]

  def index
    @orders = Order.includes(:user, :order_items).recent
  end

  def show
  end

  def update_status
    if @order.update(status: params[:status])
      redirect_to admin_orders_path, notice: "✅ Estado de orden #{@order.order_number} actualizado a #{@order.status_label}"
    else
      redirect_to admin_orders_path, alert: "Error al actualizar el estado"
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
