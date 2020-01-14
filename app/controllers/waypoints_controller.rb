class WaypointsController < ApplicationController
  before_action :set_flight
  before_action :set_waypoint, only: %i[update destroy]

  def index
    wps = Settings.theaters[@flight.theater].waypoints.map do |wp|
      { name: wp.name, pos: position(wp) }
    end
    wps = wps.select { |wp| wp[:name].downcase.include? params[:q].downcase } if params[:q]
    render json: wps
  end

  def create
    @waypoint = @flight.waypoints.build(waypoint_params)

    if @waypoint.save
      render @waypoint
    else
      head :bad_request
    end
  end

  def update
    if @waypoint.update(waypoint_params)
      render @waypoint
    else
      head :bad_request
    end
  end

  def destroy
    @waypoint.destroy
    redirect_to flight_path(@flight), notice: 'Waypoint was successfully destroyed.'
  end

  def copy_from
    @flight.waypoints.destroy_all
    src_flight = Flight.find params[:waypoints][:flight]
    src_flight.waypoints.each do |wp|
      new_wp = wp.dup
      new_wp.flight = @flight
      new_wp.save!
    end
    redirect_to flight_path(@flight), notice: 'Waypoints successfully copied.'
  end

  private

  def set_flight
    @flight = Flight.find(params[:flight_id])
  end

  def set_waypoint
    @waypoint = @flight.waypoints.find(params[:id])
  end

  def waypoint_params
    params.permit(:name, :position, :altitude, :tot)
  end

  def position(wp)
    pos = Position.new(latitude: wp.lat, longitude: wp.lon, pos: wp.pos, dme: wp.dme)
    pos.to_s(type: (@flight.airframe == 'f18' || @flight.airframe == 'av8b' ? :dms : :dm))
  end
end
