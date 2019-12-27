class RenameArrivalInFlight < ActiveRecord::Migration[6.0]
  def change
    rename_column :flights, :arrival, :recovery
  end
end
