class Api::BulkShipmentsController < ApplicationController

  def index
    search_keyword = params[:search_keyword]
    @bulk_shipments = BulkShipment.all.where('name like ?' , "%#{search_keyword}%").order(created_at: :desc)
    render format: :json
  end

  def create
    @bulk_shipment = BulkShipment.new(bulk_shipment_params)
    @bulk_shipment.save
    render format: :json
  end

  def update
    @bulk_shipment = BulkShipment.find(bulk_shipment_params[:id])
    previous_phase = @bulk_shipment.phase
    current_phase = bulk_shipment_params[:phase]
    @bulk_shipment.update(bulk_shipment_params)
    shipping_items = shipping_items_with_check_validation

    if previous_phase != current_phase && current_phase == "preparing" # TODO
      @bulk_shipment.stock_records.destroy_all
    end

    shipping_items.each do |shipping_item|
      shipping_item = shipping_item.slice(*BulkShippingItem.column_names)
      if shipping_item["id"] && BulkShippingItem.find(shipping_item["id"])  #update
        bulk_shipping_item = @bulk_shipment.bulk_shipping_items.find(shipping_item["id"])
        bulk_shipping_item.update(shipping_item)
        if previous_phase != current_phase && previous_phase == "preparing"
          @bulk_shipment.stock_records.create(quantity: bulk_shipping_item[:quantity], product_id: bulk_shipping_item[:product_id])
        end
      else  #create
        @bulk_shipment.bulk_shipping_items.build(shipping_item).save
      end
    end

    render format: :json
  end

  def destroy
    @bulk_shipment = BulkShipment.find(params[:id])
    @bulk_shipment.destroy
    render format: :json
  end

  def show
  end

  def phases
    render format: :json
  end

  private
    def bulk_shipment_params
      tmp_params = params.require(:bulk_shipment).permit(:id, :arrived_date, :delivery_charge, :from,
    :to, :tracking_number, :delivery_agent_id, :name, :phase, :ship_date)
    end

    def shipping_items_with_check_validation
      shipping_items = JSON.parse(params[:shipping_items]) if params[:shipping_items]

      if shipping_items && shipping_items.empty? == false
        shipping_items.map do |shipping_item|
          item = Product.find_by(code: shipping_item["product_id"])
          raise RuntimeError, "set product の code が存在しません" if item.nil?
          shipping_item["product_id"] = item.id
          shipping_item
        end
      else
        return []
      end
      shipping_items 
    end

end
