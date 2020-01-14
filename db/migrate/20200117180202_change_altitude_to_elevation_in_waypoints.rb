class ChangeAltitudeToElevationInWaypoints < ActiveRecord::Migration[6.0]
  def change
    rename_column :waypoints, :altitude, :elevation
  end
end
