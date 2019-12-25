class CreatePilots < ActiveRecord::Migration[6.0]
  def change
    create_table :pilots do |t|
      t.timestamps

      t.references :flight, null: false, foreign_key: true
      t.integer :number
      t.string :name
    end
  end
end
