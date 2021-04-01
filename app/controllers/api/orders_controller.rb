class Api::OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    search_keyword = params[:search_keyword]
    @orders = Order.all.where('order_number like ? or address like ? or customer_name like ? or phone_number like ? or postal_code like ? ', "%#{search_keyword}%", "%#{search_keyword}%", "%#{search_keyword}%", "%#{search_keyword}%", "%#{search_keyword}%")
    render format: :json
  end

  def create
    shipping_items = shipping_items_with_check_validation
    @order = Order.new(order_params)
    @order.save
    shipping_items.each do |shipping_item|
      @order.shipping_items.build(shipping_item).save
    end
    render format: :json
  end

  def update
    p params
    p shipping_items = shipping_items_with_check_validation
    @order = Order.find(order_params[:id])
    @order.update(order_params)
    shipping_items.each do |shipping_item|
      shipping_item = shipping_item.slice(*ShippingItem.column_names)
      if shipping_item["id"] && ShippingItem.find(shipping_item["id"])  #update
        p "------------"
        p shipping_item
        @order.shipping_items.find(shipping_item["id"]).update(shipping_item)
      else  #create
        @order.shipping_items.build(shipping_item).save
      end
    end
    render format: :json
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    render format: :json
  end

  def show
  end

  private
    def order_params
      params.require(:order).permit(:order_number, :customer_name, :postal_code, :prefecture,
    :phone_country, :phone_number, :delivery_charge, :platform, :status, :address, :id)
    end

    def shipping_items_with_check_validation
      shipping_items = JSON.parse(params[:shipping_items]) if params[:shipping_items]

      if shipping_items && shipping_items.empty? == false
        shipping_items.map do |shipping_item|
          item = Product.find_by(code: shipping_item["product_id"])
          raise RuntimeError, "set product の code が存在しません" if item.nil?
          shipping_item["product_id"] = item.id
          shipping_item
        end
      else
        raise RuntimeError, "最低1つはset product が必要です。" 
      end
      shipping_items 
    end

end
