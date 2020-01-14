class AirbasesController < ApplicationController
  def index
    theater = Settings.theaters[params['flight']['theater']]
    @airbases = theater.airbases&.map { |airbase| [airbase.last.name, airbase.first] } || []
    ab = theater.airbases&.first&.last
    @departures = ab&.departures.to_h.invert
    @recoveries = ab&.recoveries.to_h.invert
  end

  def procedures
    airbase_type, airbase = procedure_param
    airbase_settings = airbases[airbase]
    @id = airbase_map[airbase_type].last
    if airbase_settings.present?
      @procedures = airbase_settings.send(airbase_map[airbase_type].first).to_h.invert
    else
      @procedures = []
    end
  end

  private

  def procedure_param
    params.require('flight').permit(*airbase_map.keys).to_h.to_a.flatten.map(&:to_sym)
  end

  def airbase_map
    @airbase_map ||= {
      start_airbase: %i[departures flight_departure],
      land_airbase: %i[recoveries flight_recovery],
      divert_airbase: %i[recoveries flight_divert]
    }
  end

  def airbases
    @airbases ||= Settings.theaters.map { |t| t.last.airbases }.compact.map { |abs| abs.map { |a| [a.first, a.last] } }.flatten(1).to_h
  end
end
