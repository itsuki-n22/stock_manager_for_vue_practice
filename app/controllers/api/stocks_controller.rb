class Api::StocksController < ApplicationController
  skip_before_action :verify_authenticity_token
  def update
    @stock = Stock.find(params[:id])
    @stock.update(quantity: params[:quantity])
    render formats: :json
  end
end
