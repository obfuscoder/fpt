class AddSupportToFlights < ActiveRecord::Migration[6.0]
  def change
    add_column :flights, :support, :string
  end
end
