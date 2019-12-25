class WaypointsController < ApplicationController
  before_action :set_flight
  before_action :set_waypoint, only: %i[show edit update destroy]

  def index
    @waypoints = @flight.waypoints
  end

  def new
    @waypoint = @flight.waypoints.build
  end

  def edit; end

  def create
    @waypoint = @flight.waypoints.build(waypoint_params)

    if @waypoint.save
      redirect_to flight_waypoints_path(@flight), notice: 'Waypoint was successfully created.'
    else
      render :new
    end
  end

  def update
    if @waypoint.update(waypoint_params)
      redirect_to flight_waypoints_path(@flight), notice: 'Waypoint was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @waypoint.destroy
    redirect_to flight_waypoints_path(@flight), notice: 'Flight was successfully destroyed.'
  end

  private

  def set_flight
    @flight = Flight.find(params[:flight_id])
  end

  def set_waypoint
    @waypoint = @flight.waypoints.find(params[:id])
  end

  def waypoint_params
    params.require(:waypoint).permit(:name, :position, :altitude)
  end
end
