class Api::OrderMemosController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    order = Order.find(order_params[:id])
    order.create_memo(memo_params)
    render formats: :json
  end

  def update
    OrderMemo.find(memo_params[:id]).update(memo_params)
    render formats: :json
  end

  private
    def memo_params
      params.require(:memo).permit(:id, :content)
    end

    def order_params
      params.require(:order).permit(:id)
    end
end
