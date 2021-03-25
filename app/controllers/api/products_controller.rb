class Api::ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def index
    search_keyword = params[:search_keyword]
    @products = Product.left_joins(:alias_ids).distinct
    @products = @products.where(['products.name like ? or products.code like ? or alias_ids.code like ?', "%#{search_keyword}%", "%#{search_keyword}%", "%#{search_keyword}%"]).references(:alias_ids) if search_keyword
    render formats: :json
  end

  def create
    @product = Product.new(create_params)
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
    @product = Product.find(update_params[:id])
    @product.update(update_params)
    save_alias_ids
    check_set_products
    update_set_products_if_it_set
    render formats: :json
  end

  def import
    Product.import(params[:csv])
  end

  private

    def create_params
      params.require(:product).permit(:code, :name, :price, :explain, :is_set, :images)
    end

    def update_params
      params.require(:product).permit(:id, :code, :name, :price, :explain, :is_set, :images)
    end

    def alias_ids_params
      params.require(:alias_ids).permit(:sku, :asin, :other_id, :car_id)
    end
  
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

    def update_set_products_if_it_set ### params[:set_products] がない場合、差分は削除します。
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
        next if alias_ids_params[code_type] == nil
        val = JSON.parse(alias_ids_params[code_type])
        alias_id = @product.alias_ids.find(val["id"])
        alias_id.update(code: val["code"])
      end
    end
end
