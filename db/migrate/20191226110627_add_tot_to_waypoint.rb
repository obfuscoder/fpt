class AddTotToWaypoint < ActiveRecord::Migration[6.0]
  def change
    add_column :waypoints, :tot, :time
  end
end
