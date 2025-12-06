class StoreController < ApplicationController
  def index
    @categories = Category.where(parent_id: nil).order(:name)
    @products = Product.includes(:category, :provider)

    # Filtrar por categoría
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    # Buscar por nombre
    if params[:search].present?
      @products = @products.where("name LIKE ?", "%#{params[:search]}%")
    end

    @products = @products.order(:name)
  end

  def show
    @product = Product.find(params[:id])
  end
end
