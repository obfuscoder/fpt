class MissionDataCard < Prawn::Document
  def initialize(flight)
    super()
    @flight = flight
  end

  def render
    stroke_bounds
    define_grid columns: 6, rows: 20
    cell([0, 0], [0, 5], 'MISSION DATA CARD', header: true, style: :bold)
    cell(1, 0, 'C/S', header: true)
    cell(1, 1, "#{@flight.callsign} #{@flight.callsign_number}")
    cell(1, 2, 'GRP ID', header: true)
    cell(1, 3, @flight.group_id.to_s)
    cell(1, 4, 'FREQ', header: true)
    cell(1, 5, @flight.frequency.to_s)

    cell(2, 0, 'POS', header: true)
    cell(2, 1, 'C/S', header: true)
    cell(2, 2, 'PILOT', header: true)
    cell(2, 3, 'OWN ID', header: true)
    cell(2, 4, 'LASER', header: true)
    cell(2, 5, 'TACAN', header: true)

    @flight.pilots.each_with_index do |pilot, index|
      cell(3 + index, 0, pilot.dash_number)
      cell(3 + index, 1, pilot.callsign)
      cell(3 + index, 2, pilot.name)
      cell(3 + index, 3, pilot.own_id)
      cell(3 + index, 4, pilot.laser)
      cell(3 + index, 5, pilot.tacan)
    end

    cell(7, 0, 'AIRBASE', header: true)
    cell(7, 1, 'NAME', header: true)
    cell(7, 2, 'TACAN', header: true)
    cell(7, 3, 'ATIS', header: true)
    cell(7, 4, 'GROUND', header: true)
    cell(7, 5, 'TOWER', header: true)

    airbase = Settings.theaters[@flight.theater].airbases[@flight.start_airbase]
    cell(8, 0, 'TAKEOFF')
    cell(8, 1, airbase.name)
    cell(8, 2, airbase.tacan)
    cell(8, 3, airbase.atis)
    cell(8, 4, airbase.ground)
    cell(8, 5, airbase.tower)

    airbase = Settings.theaters[@flight.theater].airbases[@flight.land_airbase]
    cell(9, 0, 'LAND')
    cell(9, 1, airbase.name)
    cell(9, 2, airbase.tacan)
    cell(9, 3, airbase.atis)
    cell(9, 4, airbase.ground)
    cell(9, 5, airbase.tower)

    airbase = Settings.theaters[@flight.theater].airbases[@flight.divert_airbase]
    cell(10, 0, 'DIVERT')
    cell(10, 1, airbase.name)
    cell(10, 2, airbase.tacan)
    cell(10, 3, airbase.atis)
    cell(10, 4, airbase.ground)
    cell(10, 5, airbase.tower)

    cell(11, 0, 'SUPPORT', header: true)
    cell(11, 1, 'C/S', header: true)
    cell(11, 2, 'TACAN', header: true)
    cell(11, 3, 'FREQ', header: true)
    cell(11, 4, 'POS', header: true)
    cell(11, 5, 'ALT', header: true)

    Settings.theaters[@flight.theater].support.each_with_index do |support, index|
      cell(12 + index, 0, support.)
      cell(12 + index, 1, airbase.name)
      cell(12 + index, 2, airbase.tacan)
      cell(12 + index, 3, airbase.atis)
      cell(12 + index, 4, airbase.ground)
      cell(12 + index, 5, airbase.tower)
    end
    super
  end

  private

  def cell(row, col, value, header: false, style: :normal)
    grid(row, col).bounding_box do
      if header
        fill_color 'c0c0c0'
        fill_rectangle bounds.top_left, bounds.width, bounds.height
        fill_color '000000'
      end
      stroke_bounds
      text_box value.to_s,
               style: style, size: 18, align: :center, valign: :center, overflow: :shrink_to_fit, inline_format: true
    end
  end
end