class Api::StockPlacesController < ApplicationController

  def index
    @stock_places = StockPlace.all
    render formats: :json
  end

end
