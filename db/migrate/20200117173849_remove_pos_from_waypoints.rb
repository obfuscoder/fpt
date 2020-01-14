class RemovePosFromWaypoints < ActiveRecord::Migration[6.0]
  def change
    remove_column :waypoints, :pos, :string
  end
end
