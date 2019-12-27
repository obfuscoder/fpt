class AirbasesController < ApplicationController
  before_action :set_theater

  def index
    @airbases = @theater.airbases&.map { |airbase| [airbase.last.name, airbase.first] } || []
    ab = @theater.airbases&.first&.last
    @departures = ab&.departures.to_h.invert
    @recoveries = ab&.recoveries.to_h.invert
  end

  private

  def set_theater
    @theater = Settings.theaters[params['flight']['theater']] if params['flight']
  end
end
