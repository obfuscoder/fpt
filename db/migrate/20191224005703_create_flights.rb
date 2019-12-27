class CreateFlights < ActiveRecord::Migration[6.0]
  def change
    create_table :flights do |t|
      t.timestamps

      t.string :theater
      t.string :airframe
      t.datetime :start
      t.integer :duration
      t.string :callsign
      t.integer :callsign_number
      t.integer :slots
      t.string :mission
      t.string :task
      t.integer :group_id
      t.integer :laser
      t.integer :tacan_channel
      t.string :tacan_polarization
      t.decimal :frequency
      t.text :notes
      t.string :loadout
      t.string :start_airbase
      t.string :land_airbase
      t.string :divert_airbase
      t.string :departure
      t.string :arrival
    end
  end
end
