class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.includes(:parent).order(:name)
  end

  def show
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to admin_categories_path, notice: "✅ Categoría creada correctamente"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "✅ Categoría actualizada correctamente"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.products.any?
      redirect_to admin_categories_path(delete_error: "category", name: @category.name)
    else
      @category.destroy
      redirect_to admin_categories_path, notice: "Categoría eliminada"
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :parent_id)
  end
end
