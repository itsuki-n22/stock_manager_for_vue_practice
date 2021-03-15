class CreateTodos < ActiveRecord::Migration[6.1]
  def change
    create_table :todos do |t|
      t.references :user, index: true, foreign_key: true
      t.string :title, null: false, default: ""
      t.string :body, default: ""

      t.timestamps
    end
  end
end
