class AddNumberIndexToWaypoints < ActiveRecord::Migration[6.0]
  def change
    add_index :waypoints, [:flight_id, :number], unique: true
  end
end
