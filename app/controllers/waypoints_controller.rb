class WaypointsController < ApplicationController
  before_action :set_flight
  before_action :set_waypoint, only: %i[update destroy]

  def index
    wps = Settings.theaters[@flight.theater].waypoints.map do |wp|
      pos = position(wp)
      { name: wp.name, dme: pos.dme || '', pos: pos.coords, lat: pos.latitude, lon: pos.longitude }
    end
    wps = wps.select { |wp| wp[:name].downcase.include? params[:q].downcase } if params[:q]
    render json: wps
  end

  def create
    pos, wp = to_position
    @waypoint = @flight.waypoints.build latitude: pos.latitude, longitude: pos.longitude, dme: pos.dme, name: wp[:name], elevation: wp[:elev], tot: wp[:tot]

    if @waypoint.save
      render @waypoint
    else
      head :bad_request
    end
  end

  def update
    pos, wp = to_position
    if @waypoint.update latitude: pos.latitude, longitude: pos.longitude, dme: pos.dme, name: wp[:name], elevation: wp[:elev], tot: wp[:tot]
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

  def to_position
    wp = waypoint_params
    pos = Position.new latitude: wp[:lat], longitude: wp[:lon], pos: wp[:pos], dme: wp[:dme]
    return pos, wp
  end

  def set_flight
    @flight = Flight.find(params[:flight_id])
  end

  def set_waypoint
    @waypoint = @flight.waypoints.find(params[:id])
  end

  def waypoint_params
    params.permit(:name, :dme, :lat, :lon, :pos, :elev, :tot)
  end

  def position(wp)
    Position.new(latitude: wp.lat, longitude: wp.lon, pos: wp.pos, dme: wp.dme)
  end
end
