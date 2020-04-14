class AddIffToFlight < ActiveRecord::Migration[6.0]
  def change
    add_column :flights, :iff, :integer
  end
end
