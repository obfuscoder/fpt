module FlightsHelper
  def airbases(flight)
    return [] unless flight&.theater

    Settings.theaters[flight.theater].airbases.map { |t| [t.last.name, t.first] }
  end

  def theater_support(theater)
    return [] unless theater

    Settings.theaters[theater].support.map { |s| OpenStruct.new({ key: s.first }.merge(s.last)) }
  end

  def departures(flight)
    return [] unless flight&.start_airbase

    Settings.theaters[flight.theater].airbases[flight.start_airbase].departures.to_h.invert
  end

  def recoveries(flight)
    return [] unless flight&.land_airbase

    Settings.theaters[flight.theater].airbases[flight.land_airbase].recoveries.to_h.invert
  end

  def diverts(flight)
    return [] unless flight&.divert_airbase

    Settings.theaters[flight.theater].airbases[flight.divert_airbase].recoveries.to_h.invert
  end

  def start_airbase(flight)
    Settings.theaters[flight.theater].airbases[flight.start_airbase] if flight.start_airbase
  end

  def land_airbase(flight)
    Settings.theaters[flight.theater].airbases[flight.land_airbase] if flight.land_airbase
  end

  def divert_airbase(flight)
    Settings.theaters[flight.theater].airbases[flight.divert_airbase] if flight.divert_airbase
  end

  def runway(airbase, runway_name)
    return unless airbase && runway_name

    airbase.runways.find { |rwy| rwy.name == runway_name }
  end

  def link_to_start_airbase(flight)
    link_to start_airbase(flight)&.name, "/#{flight.theater}/#{flight.start_airbase}/ad.pdf" if flight.start_airbase
  end

  def link_to_land_airbase(flight)
    link_to land_airbase(flight)&.name, "/#{flight.theater}/#{flight.land_airbase}/ad.pdf" if flight.land_airbase
  end

  def link_to_divert_airbase(flight)
    link_to divert_airbase(flight)&.name, "/#{flight.theater}/#{flight.divert_airbase}/ad.pdf" if flight.divert_airbase
  end

  def link_to_departure(flight)
    link_to flight.departure_name, "/#{flight.theater}/#{flight.start_airbase}/departures/#{flight.departure}.pdf" if flight.departure
  end

  def link_to_recovery(flight)
    link_to flight.recovery_name, "/#{flight.theater}/#{flight.land_airbase}/recoveries/#{flight.recovery}.pdf" if flight.recovery
  end

  def link_to_divert(flight)
    link_to flight.divert_name, "/#{flight.theater}/#{flight.land_airbase}/recoveries/#{flight.divert}.pdf" if flight.divert
  end
end
