class Api::PlatformsController < ApplicationController

  def index
    @platforms = Platform.all.order(created_at: :asc)
    render formats: :json
  end

  def create
    @platform = Platform.create!(platform_params)
    render formats: :json
  end

  def update
    @platform = Platform.find(platform_params[:id])
    @platform.update(platform_params)
    render formats: :json
  end
  
  private
    def platform_params
      params.require(:platform).permit(:id, :name, :url)
    end


end
