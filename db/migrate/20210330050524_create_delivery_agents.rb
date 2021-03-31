class CreateDeliveryAgents < ActiveRecord::Migration[6.1]
  def change
    create_table :delivery_agents do |t|
      t.string :name, null: false
      t.string :track_url

      t.timestamps
    end
  end
end
