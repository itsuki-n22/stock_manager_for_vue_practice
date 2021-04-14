class Api::BulkShippingItemsController < ApplicationController

  def destroy
    @shipping_item = BulkShippingItem.find(params[:id])
    @shipping_item.destroy
  end
end
