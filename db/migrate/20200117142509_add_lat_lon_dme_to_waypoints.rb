class AddLatLonDmeToWaypoints < ActiveRecord::Migration[6.0]
  def change
    add_column :waypoints, :dme, :string
    add_column :waypoints, :latitude, :decimal, precision: 16, scale: 14
    add_column :waypoints, :longitude, :decimal, precision: 17, scale: 14
  end
end
