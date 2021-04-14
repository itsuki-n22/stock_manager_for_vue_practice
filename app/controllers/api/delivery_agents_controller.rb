class Api::DeliveryAgentsController < ApplicationController

  def index
    @delivery_agents = DeliveryAgent.all
    render formats: :json
  end

end
