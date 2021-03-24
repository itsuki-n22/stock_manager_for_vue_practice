class Api::ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def index
    search_keyword = params[:search_keyword]
    @products = Product.left_joins(:alias_ids).distinct
    @products = @products.where(['products.name like ? or products.code like ? or alias_ids.code like ?', "%#{search_keyword}%", "%#{search_keyword}%", "%#{search_keyword}%"]).references(:alias_ids) if search_keyword
    render formats: :json
  end

  def create
    @product = Product.new(code: params[:code], name: params[:name], price: params[:price], explain: params[:explain], is_set: params[:is_set])
    @product.images = params[:images]
    check_set_products
    @product.save
    save_set_products_if_it_set
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
    save_alias_ids
    check_set_products
    update_set_products_if_it_set
    render formats: :json
  end

  private
  
    def check_set_products
      set_products = JSON.parse(params[:set_products]) if params[:set_products]
      if @product.is_set?
        if set_products.empty? == false
          set_products.each do |set_product|
            item = Product.find_by(code: set_product["code"])
            raise RuntimeError, "set product の code が存在しません" if item.nil?
          end
        else
          raise RuntimeError, "最低1つはset product が必要です。" 
        end
      end
    end

    def save_set_products_if_it_set
      if @product.is_set && params[:set_products]
        JSON.parse(params[:set_products]).each do |set_product|
          item = Product.find_by(code: set_product["code"])
          @product.add_set_item(item, set_product["quantity"])
        end
      end
    end

    def update_set_products_if_it_set
      if @product.is_set && params[:set_products]
        @product.set_products.destroy_all
        JSON.parse(params[:set_products]).each do |set_product|
          item = Product.find_by(code: set_product["code"])
          @product.add_set_item(item, set_product["quantity"])
        end
      end
    end

    def save_alias_ids
      AliasId.code_types.each do |code_type, code_num|
        val = JSON.parse(params[code_type])
        alias_id = @product.alias_ids.find(val["id"])
        alias_id.update(code: val["code"])
      end
    end
end
