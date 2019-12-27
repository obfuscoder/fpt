class AddDivertToFlight < ActiveRecord::Migration[6.0]
  def change
    add_column :flights, :divert, :string
  end
end
