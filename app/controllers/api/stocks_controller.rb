class Api::StocksController < ApplicationController
  def update # 後でstock_details controllerを作ってそっちへ移動すべきかも
    @stock = Stock.find(params[:id])
    dist = @stock.quantity - params[:quantity].to_i
    stock_correction = @stock.product.stock_corrections.create(quantity: dist, price: @stock.ave_price) # あとでpriceを変更できるようにする
    stock_correction.create_stock_record(stock_place_id: @stock.stock_place_id, 
    quantity: dist, product_id: @stock.product_id, new_price: @stock.ave_price )
    render formats: :json
  end
end
