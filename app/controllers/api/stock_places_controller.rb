class Api::StockPlacesController < ApplicationController

  def index
    @stock_places = StockPlace.all.order(created_at: :asc)
    render formats: :json
  end

  def create
    @stock_place = StockPlace.create!(stock_place_params)
    render formats: :json
  end

  def update
    @stock_place = StockPlace.find(stock_place_params[:id])
    @stock_place.update(stock_place_params)
    render formats: :json
  end
  
  private
    def stock_place_params
      params.require(:stock_place).permit(:id, :name)
    end

end
