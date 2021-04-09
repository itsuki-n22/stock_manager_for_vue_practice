class ChangePlatformColumnToReferenceColumnInOrderModel < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :platform, :integer
    add_reference :orders, :platform, foreign_key: true
  end
end
