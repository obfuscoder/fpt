class AddMinimumWeatherRequirementsToFlight < ActiveRecord::Migration[6.0]
  def change
    add_column :flights, :minimum_weather_requirements, :string
  end
end
