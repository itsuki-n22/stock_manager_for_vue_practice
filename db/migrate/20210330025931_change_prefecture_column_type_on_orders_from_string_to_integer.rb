class ChangePrefectureColumnTypeOnOrdersFromStringToInteger < ActiveRecord::Migration[6.1]
  def change
    change_column :orders, :prefecture, 'integer USING prefecture::integer'
  end
end
