class CreateFlights < ActiveRecord::Migration[6.0]
  def change
    create_table :flights do |t|
      t.string :theater
      t.string :airframe
      t.datetime :start
      t.integer :duration
      t.string :callsign
      t.integer :callsign_number
      t.integer :slots
      t.string :mission
      t.string :objectives
      t.integer :group_id
      t.integer :laser
      t.integer :tacan_channel
      t.string :tacan_polarization
      t.decimal :frequency
      t.text :notes

      t.timestamps
    end
  end
end
