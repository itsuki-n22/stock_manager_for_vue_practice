class Api::ProductMemosController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    product = Product.find(product_params[:id])
    product.create_memo(memo_params)
    render formats: :json
  end

  def update
    ProductMemo.find(memo_params[:id]).update(memo_params)
    render formats: :json
  end

  private
    def memo_params
      params.require(:memo).permit(:id, :content)
    end

    def product_params
      params.require(:product).permit(:id)
    end
end
