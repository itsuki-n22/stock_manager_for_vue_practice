class Api::DeliveryAgentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @delivery_agents = DeliveryAgent.all
    render formats: :json
  end

end
