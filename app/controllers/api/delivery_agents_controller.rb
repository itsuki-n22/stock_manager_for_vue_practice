class Api::DeliveryAgentsController < ApplicationController

  def index
    @delivery_agents = DeliveryAgent.all.order(created_at: :asc)
    render formats: :json
  end

  def create
    @delivery_agent = DeliveryAgent.create!(delivery_agent_params)
    render formats: :json
  end

  def update
    @delivery_agent = DeliveryAgent.find(delivery_agent_params[:id])
    @delivery_agent.update(delivery_agent_params)
    render formats: :json
  end
  
  private
    def delivery_agent_params
      params.require(:delivery_agent).permit(:id, :name, :track_url)
    end


end
