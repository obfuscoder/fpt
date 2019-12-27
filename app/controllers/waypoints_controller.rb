class WaypointsController < ApplicationController
  before_action :set_flight
  before_action :set_waypoint, only: %i[edit update destroy]

  def new
    @waypoint = @flight.waypoints.build number: @flight.waypoints.count + 1
  end

  def edit; end

  def create
    params[:waypoint].delete_if{ |k,v| v.empty? }
    @waypoint = @flight.waypoints.build(waypoint_params)

    respond_to do |format|
      if @waypoint.save
        format.js
        format.html { redirect_to flight_path(@flight), notice: 'Waypoint was successfully created.' }
      else
        format.js
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @waypoint.update(waypoint_params)
        format.js
        format.html { redirect_to flight_path(@flight), notice: 'Waypoint was successfully updated.' }
      else
        format.js
        format.html { render :edit }
      end

    end
  end

  def destroy
    @waypoint.destroy
    redirect_to flight_path(@flight), notice: 'Waypoint was successfully destroyed.'
  end

  private

  def set_flight
    @flight = Flight.find(params[:flight_id])
  end

  def set_waypoint
    @waypoint = @flight.waypoints.find(params[:id])
  end

  def waypoint_params
    params.require(:waypoint).permit(:name, :position, :altitude, :tot)
  end
end
