class Api::StockPlacesController < ApplicationController

  def index
    @stock_places = StockPlace.all.order(created_at: :asc)
    render formats: :json
  end

  def create
    @stock_place = StockPlace.create!(stock_place_params)
    Product.all.each do |product|
      product.stocks.create(stock_place_id: @stock_place.id)
    end
    render formats: :json
  end

  def update
    @stock_place = StockPlace.find(stock_place_params[:id])
    @stock_place.update(stock_place_params)
    render formats: :json
  end

  def defaults
    @default_stock_place_without_quantity = StockPlace.all.where(has_quantity: false).first
    @default_stock_place_with_quantity = StockPlace.all.where(has_quantity: true).first
  end
  
  private
    def stock_place_params
      params.require(:stock_place).permit(:id, :name, :has_quantity)
    end

end
