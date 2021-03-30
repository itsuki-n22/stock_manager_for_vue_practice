class CreateOrderMemos < ActiveRecord::Migration[6.1]
  def change
    create_table :order_memos do |t|
      t.references :order, null: false, foreign_key: true
      t.string :content

      t.timestamps
    end
  end
end
