class LoadoutController < ApplicationController
  before_action :set_flight

  def edit
    @loadout = Loadout.parse @flight.loadout
    @stations = Settings.loadout.send(@flight.airframe).map { |config| Station.new(config, Settings.weapons) }
  end

  def update
    @loadout = Loadout.new loadout_params
    @flight.update loadout: @loadout
    redirect_to flight_path(@flight)
  end

  private

  def set_flight
    @flight = Flight.find(params[:flight_id])
  end

  def loadout_params
    params.require(:loadout).permit(Settings.loadout.send(@flight.airframe).keys)
  end
end
