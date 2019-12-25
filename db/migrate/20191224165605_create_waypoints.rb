class CreateWaypoints < ActiveRecord::Migration[6.0]
  def change
    create_table :waypoints do |t|
      t.references :flight, null: false, foreign_key: true
      t.integer :number
      t.string :name
      t.string :position
      t.string :altitude

      t.timestamps
    end
  end
end
