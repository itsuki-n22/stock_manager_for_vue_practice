class CreateAliasIdKinds < ActiveRecord::Migration[6.1]
  def change
    create_table :alias_id_kinds do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.string :url

      t.timestamps
    end
  end
end
