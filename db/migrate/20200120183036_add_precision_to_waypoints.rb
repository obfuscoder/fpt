class AddPrecisionToWaypoints < ActiveRecord::Migration[6.0]
  def change
    add_column :waypoints, :precision, :integer
  end
end
