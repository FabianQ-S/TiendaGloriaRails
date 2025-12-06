class Admin::DashboardController < Admin::BaseController
  def index
    @products_count = Product.count
    @categories_count = Category.count
    @users_count = User.count
    @orders_count = Order.count
    @providers_count = Provider.count
    @recent_orders = Order.order(created_at: :desc).limit(5)
  end
end
