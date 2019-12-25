class PilotsController < ApplicationController
  def create
    flight = Flight.find params[:flight_id]

    pilot = Pilot.new pilot_params.merge(flight: flight)

    if pilot.save
      redirect_back fallback_location: flight_path(flight), notice: 'Pilot assigned.'
    else
      redirect_back fallback_location: flight_path(flight), alert: 'Pilot could not be assigned!'
    end
  end

  def destroy
    flight = Flight.find params[:flight_id]
    flight.pilots.destroy params[:id]
    redirect_back fallback_location: flight_path(flight), notice: 'Pilot unassigned.'
  end

  private

  def pilot_params
    params.require(:pilot).permit(:number, :name)
  end
end
