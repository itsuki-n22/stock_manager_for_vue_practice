class CreateProductMemos < ActiveRecord::Migration[6.1]
  def change
    create_table :product_memos do |t|
      t.references :product, null: false, foreign_key: true
      t.string :content

      t.timestamps
    end
  end
end
