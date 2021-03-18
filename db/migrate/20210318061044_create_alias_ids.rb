class CreateAliasIds < ActiveRecord::Migration[6.1]
  def change
    create_table :alias_ids do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :code_type, null: false
      t.string :code, null: false
      t.timestamps
    end
  end
end
