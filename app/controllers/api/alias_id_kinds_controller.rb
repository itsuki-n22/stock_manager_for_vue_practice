class Api::AliasIdKindsController < ApplicationController

  def index
    @alias_id_kinds = AliasIdKind.all.order(created_at: :asc)
    render formats: :json
  end

  def create
    @alias_id_kind = AliasIdKind.create!(alias_id_kind_params)
    render formats: :json
  end

  def update
    @alias_id_kind = AliasIdKind.find(alias_id_kind_params[:id])
    @alias_id_kind.update(alias_id_kind_params)
    render formats: :json
  end
  
  private
    def alias_id_kind_params
      params.require(:alias_id_kind).permit(:id, :name, :code, :url)
    end


end
