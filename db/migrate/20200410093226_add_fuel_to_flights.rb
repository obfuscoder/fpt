class AddFuelToFlights < ActiveRecord::Migration[6.0]
  def change
    add_column :flights, :target_fuel, :integer
    add_column :flights, :joker_fuel, :integer
    add_column :flights, :bingo_fuel, :integer
    add_column :flights, :landing_fuel, :integer
  end
end
