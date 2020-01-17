class RemovePositionFromWaypoints < ActiveRecord::Migration[6.0]
  def change
    remove_column :waypoints, :position, :string
  end
end
