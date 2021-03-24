class AddIsSetToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :is_set, :boolean, default: false
  end
end
