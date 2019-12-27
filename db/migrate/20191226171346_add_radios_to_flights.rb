class AddRadiosToFlights < ActiveRecord::Migration[6.0]
  def change
    add_column :flights, :radio1, :string
    add_column :flights, :radio2, :string
    add_column :flights, :radio3, :string
    add_column :flights, :radio4, :string
  end
end
