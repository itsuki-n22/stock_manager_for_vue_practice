class Api::StocksController < ApplicationController
  def update
    @stock = Stock.find(params[:id])
    @stock.update(quantity: params[:quantity])
    render formats: :json
  end
end
