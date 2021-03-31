class Api::ShippingItemsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def destroy
    @shipping_item = ShippingItem.find(params[:id])
    @shipping_item.destroy
  end
end
