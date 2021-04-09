class Api::PlatformsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @platforms = Platform.all
    render formats: :json
  end

end
