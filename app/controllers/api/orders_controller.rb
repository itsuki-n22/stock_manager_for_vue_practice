class Api::OrdersController < ApplicationController

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
    shipping_items = shipping_items_with_check_validation
    @order = Order.find(order_params[:id])
    @order.update(order_params)
    shipping_items.each do |shipping_item|
      shipping_item = shipping_item.slice(*ShippingItem.column_names)
      prohibit_already_sent_item_flag = false
      if shipping_item["id"] && ShippingItem.find(shipping_item["id"])  #update
        old_shipping_item = @order.shipping_items.find(shipping_item["id"])
        next if old_shipping_item["is_sent"] == true && shipping_item["is_sent"] == true #発送済みの場合 is_sent以外は修正できない
        prohibit_already_sent_item_flag = true if old_shipping_item["is_sent"] == shipping_item["is_sent"] 
        old_shipping_item.update(shipping_item)
        if old_shipping_item[:is_sent] #元々配送済み状態でない
          if old_shipping_item.departure.has_quantity?
            old_shipping_item.stock_records.create(quantity: -1 * old_shipping_item[:quantity],
              stock_place_id: old_shipping_item[:from],
              product_id: old_shipping_item[:product_id])
          end

          if old_shipping_item.destination.has_quantity?
            old_shipping_item.stock_records.create(quantity: old_shipping_item[:quantity],
              stock_place_id: old_shipping_item[:to],
              product_id: old_shipping_item[:product_id])
          end

        else # 元々配送済み状態である
          next if prohibit_already_sent_item_flag
          old_shipping_item.stock_records.destroy_all
        end
        
      else  #create
        next if shipping_item[:is_sent] # 登録されていないのに発送済みにならないようにする
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
      tmp_params = params.require(:order).permit(:order_number, :customer_name, :postal_code, :prefecture,
    :phone_country, :phone_number, :delivery_charge, :platform_id, :status, :address, :id)
    end

    def shipping_items_with_check_validation
      shipping_items = JSON.parse(params[:shipping_items]) if params[:shipping_items]

      if shipping_items && shipping_items.empty? == false
        shipping_items.map do |shipping_item|
          p item = Product.find_by(code: shipping_item["product_id"])
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
