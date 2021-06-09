class UpdateFrequencyOfFlights < ActiveRecord::Migration[6.0]
  def change
    change_column :flights, :frequency, :decimal, precision: 6, scale: 3
  end
end
