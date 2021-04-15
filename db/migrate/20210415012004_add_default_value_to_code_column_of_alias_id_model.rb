class AddDefaultValueToCodeColumnOfAliasIdModel < ActiveRecord::Migration[6.1]
  def change
    change_column :alias_ids, :code, :string, default: ""
  end
end
