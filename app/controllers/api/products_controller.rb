class Api::ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @products = Product.all.order(:code)
    render formats: :json
  end
  def create
    @product = Product.new(code: params[:code], name: params[:name], price: params[:price])
    @product.images = params[:images]
    @product.save
    @product.init_stocks
    p "hellllo create"
    render formats: :json
  end
  def destroy
    @product = Product.find(params[:id])
    @product.delete
    render formats: :json
  end
  def show
    @product = Product.find(params[:id])
  end
  def update
    @product = Product.find(params[:id])
    @product.update(code: params[:code], name: params[:name], price: params[:price])
    render formats: :json
  end
end
