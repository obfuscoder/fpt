class AddFormatToWaypoints < ActiveRecord::Migration[6.0]
  def change
    add_column :waypoints, :format, :integer
  end
end
