class AddAoToFlight < ActiveRecord::Migration[6.0]
  def change
    add_column :flights, :ao, :string
  end
end
