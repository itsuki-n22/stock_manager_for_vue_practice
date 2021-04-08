class ChangeCodeTypeColumnToAliasIdKindColumnInAliasId < ActiveRecord::Migration[6.1]
  def change
    remove_column :alias_ids, :code_type, :integer
    add_reference :alias_ids, :alias_id_kind
  end
end
