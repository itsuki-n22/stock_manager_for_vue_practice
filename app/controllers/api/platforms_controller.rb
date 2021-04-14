class Api::PlatformsController < ApplicationController

  def index
    @platforms = Platform.all
    render formats: :json
  end

end
