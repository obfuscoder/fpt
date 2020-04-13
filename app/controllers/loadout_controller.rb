class LoadoutController < ApplicationController
  before_action :set_flight

  def edit
    @loadout = Loadout.parse @flight.airframe, @flight.loadout
    @stations = Settings.loadout.send(@flight.airframe).map { |config| Station.new(config) }
  end

  def update
    @loadout = Loadout.new @flight.airframe, loadout_params
    @flight.update loadout: @loadout
    redirect_to flight_path(@flight)
  end

  private

  def set_flight
    @flight = Flight.find(params[:flight_id])
  end

  def loadout_params
    params.require(:loadout).permit(Settings.loadout.send(@flight.airframe).keys + %w[f e g])
  end
end
