class Api::ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    search_keyword = params[:search_keyword]
    @products = Product.left_joins(:alias_ids).distinct
    @products = @products.where(['products.code like ? or alias_ids.code like ?', "%#{search_keyword}%", "%#{search_keyword}%"]).references(:alias_ids) if search_keyword
    render formats: :json
  end
  def create
    @product = Product.new(code: params[:code], name: params[:name], price: params[:price], explain: params[:explain])
    @product.images = params[:images]
    @product.save
    @product.init_params
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
    @product.update(code: params[:code], name: params[:name], price: params[:price], explain: params[:explain])
    AliasId.code_types.each do |code_type, code_num|
      val = JSON.parse(params[code_type])
      alias_id = @product.alias_ids.find(val["id"])
      alias_id.update(code: val["code"])
    end
    render formats: :json
  end
end
