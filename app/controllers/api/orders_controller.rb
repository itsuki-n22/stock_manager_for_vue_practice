class Api::OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    search_keyword = params[:search_keyword]
    @orders = Order.all.where('order_number like ? or address like ? or customer_name like ? or phone_number like ? or postal_code like ? ', "%#{search_keyword}%", "%#{search_keyword}%", "%#{search_keyword}%", "%#{search_keyword}%", "%#{search_keyword}%")
    render format: :json
  end

  def create
    @order = Order.new(order_params)
    @order.save
    render format: :json
  end

  def update
    @order = Order.find(order_params[:id])
    @order.update(order_params)
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
end
