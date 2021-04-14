class Api::ShippingItemsController < ApplicationController

  def destroy
    @shipping_item = ShippingItem.find(params[:id])
    @shipping_item.destroy
  end
end
