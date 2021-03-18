class ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
  end
  def create
    product = Product.new(product_params)

    if product.save
      render json: product, status: :created
    else
      render json: product.errors, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :code, :explain, :price, :image)
  end

  def show
  end
end
