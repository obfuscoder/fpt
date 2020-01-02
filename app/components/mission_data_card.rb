class MissionDataCard < Prawn::Document
  def initialize(flight, options = {})
    super(options.merge(page_size: [540, 814], margin: 10))

    font_families.update 'freesans' => {
      normal: 'lib/assets/ttf/FreeSans.ttf',
      bold: 'lib/assets/ttf/FreeSansBold.ttf',
      italic: 'lib/assets/ttf/FreeSansOblique.ttf',
      bold_italic: 'lib/assets/ttf/FreeSansBoldOblique.ttf'
    }
    font 'freesans'

    @flight = flight
    @row = 0
  end

  def render
    set_white_background

    flight_info
    airbases
    support
    other_flights
    start_new_page
    flight_plan
    comms
    notes
    super
  end

  private

  def flight_info
    define_columns 6

    header('MISSION DATA CARD')

    cell(0, 'Callsign', header: true)
    cell(1, @flight.full_callsign)
    cell(2, 'Mission', header: true)
    cell(3, @flight.mission)
    cell(4, 'Comms', header: true)
    cell(5, @flight.frequency)
    next_row

    cell(0, 'AO', header: true)
    cell(1, @flight.ao)
    cell(2, 'Departure', header: true)
    cell(3, @flight.departure_name)
    cell(4, 'Recovery', header: true)
    cell(5, @flight.recovery_name)
    next_row

    cell(0, 'Task', header: true)
    cell([1, 5], @flight.task)
    next_row

    cell(0, '#', header: true)
    cell(1, 'Callsign', header: true)
    cell(2, 'Pilot', header: true)
    cell(3, 'Net Id', header: true)
    cell(4, 'Lasercode', header: true)
    cell(5, 'TACAN', header: true)
    next_row

    @flight.pilots.each do |pilot|
      cell(0, pilot.dash_number)
      cell(1, pilot.callsign)
      cell(2, pilot.name)
      cell(3, pilot.net_id)
      cell(4, pilot.laser)
      cell(5, pilot.tacan)
      next_row
    end
    next_row
  end

  def other_flights
    flights = @flight.others
    return if flights.empty?

    define_columns 12
    header('OTHER FLIGHTS')

    cell([0, 1], 'Callsign', header: true)
    cell([2, 3], 'Mission', header: true)
    cell([4, 5], 'Airframe', header: true)
    cell(6, 'Freq', header: true)
    cell(7, 'TCN', header: true)
    cell(8, 'GrpId', header: true)
    cell(9, 'Laser', header: true)
    cell([10, 11], 'AO', header: true)
    next_row

    flights.each do |flight|
      cell([0, 1], flight.full_callsign)
      cell([2, 3], flight.mission)
      cell([4, 5], flight.airframes)
      cell(6, flight.frequency)
      cell(7, flight.tacan_channels)
      cell(8, flight.group_id)
      cell(9, flight.laser_mask)
      cell([10, 11], flight.ao)
      next_row
    end
    next_row
  end

  def support
    support = @flight.selected_support
    return if support.empty?

    define_columns 11
    header('SUPPORT')

    cell([0, 1], 'Type', header: true)
    cell([2, 3], 'Callsign', header: true)
    cell(4, 'Comms', header: true)
    cell(5, 'TCN', header: true)
    cell([6, 8], 'Location', header: true)
    cell(9, 'Altitude', header: true)
    cell(10, 'Speed', header: true)
    next_row

    support.each do |s|
      cell([0, 1], s.type)
      cell([2, 3], s.callsign)
      cell(4, s.comms)
      cell(5, s.tacan)
      cell([6, 8], s.position)
      cell(9, s.altitude)
      cell(10, s.speed)
      next_row
    end
    next_row
  end

  def next_row
    @row += 1
  end

  def comms
    comms = 1.upto(4).map { |num| [num, @flight.send("radio#{num}")] }.select { |e| e.last.present? }
    return if comms.empty?

    define_columns 11
    header('COMMS')

    cell(0, 'Radio', header: true)
    cell([1, 10], 'Usage', header: true)
    next_row

    comms.each do |c|
      cell(0, c.first)
      cell([1, 10], c.last)
      next_row
    end
    next_row
  end

  def notes
    return if @flight.notes.blank?

    define_columns 1
    header('NOTES')
    cell(0, "\n#{@flight.notes}", valign: :top, rows: (@grid.rows - @row))
  end

  def flight_plan
    return if @flight.waypoints.empty?

    define_columns 11
    header('FLIGHTPLAN')

    cell(0, '#', header: true)
    cell([1, 2], 'Name', header: true)
    cell([3, 8], 'Navaid/Coords/DME', header: true)
    cell(9, 'Altitude', header: true)
    cell(10, 'TOT', header: true)
    next_row

    @flight.waypoints.each do |wp|
      cell(0, wp.number)
      cell([1, 2], wp.name)
      cell([3, 8], wp.position)
      cell(9, wp.altitude)
      cell(10, wp.tot&.to_s(:time))
      next_row
    end
    next_row
  end

  def airbases
    define_columns 11
    header('AIRBASES')

    cell(0, '', header: true)
    cell([1, 3], 'Name', header: true)
    cell(4, 'TCN', header: true)
    cell(5, 'ATIS', header: true)
    cell(6, 'Ground', header: true)
    cell(7, 'Tower', header: true)
    cell(8, 'RWY', header: true)
    cell(9, 'Elev', header: true)
    cell(10, 'ILS', header: true)
    next_row

    airbase = Settings.theaters[@flight.theater].airbases[@flight.start_airbase]
    cell(0, 'Dep')
    cell([1, 3], airbase.name)
    cell(4, airbase.tacan)
    cell(5, airbase.atis)
    cell(6, airbase.ground)
    cell(7, airbase.tower)
    cell(8, airbase.takeoff)
    cell(9, airbase.elevation)
    cell(10, airbase.ils)
    next_row

    airbase = Settings.theaters[@flight.theater].airbases[@flight.land_airbase]
    cell(0, 'Arr')
    cell([1, 3], airbase.name)
    cell(4, airbase.tacan)
    cell(5, airbase.atis)
    cell(6, airbase.ground)
    cell(7, airbase.tower)
    cell(8, airbase.land)
    cell(9, airbase.elevation)
    cell(10, airbase.ils)
    next_row

    if @flight.divert_airbase
      airbase = Settings.theaters[@flight.theater].airbases[@flight.divert_airbase]
      cell(0, 'Div')
      cell([1, 3], airbase.name)
      cell(4, airbase.tacan)
      cell(5, airbase.atis)
      cell(6, airbase.ground)
      cell(7, airbase.tower)
      cell(8, airbase.land)
      cell(9, airbase.elevation)
      cell(10, airbase.ils)
      next_row
    end

    next_row
  end

  def define_columns(cols)
    define_grid columns: cols, rows: 30
  end

  def header(title)
    cell([0, @grid.columns - 1], title, header: true, style: :bold, align: :center)
    next_row
  end

  def cell(col, value, header: false, style: :normal, align: :left, valign: :center, rows: 1)
    from = col.kind_of?(Array) ? [@row, col.first] : [@row, col]
    to = col.kind_of?(Array) ? [@row + rows - 1, col.last] : [@row + rows - 1, col]
    grid(from, to).bounding_box do
      fill_color header ? 'c0c0c0' : 'ffffff'
      fill_rectangle bounds.top_left, bounds.width, bounds.height
      fill_color '000000'

      stroke_bounds
      indent(3, 3) do
        options = { style: style, size: 12, align: align, valign: valign, overflow: :shrink_to_fit, inline_format: true }
        text_box value.to_s, options
      end
    end
  end

  def start_new_page(options = {})
    super(options)

    @row = 0

    set_white_background
  end

  def set_white_background
    color = fill_color
    canvas do
      fill_color 'ffffff'
      fill_rectangle([bounds.left, bounds.top], bounds.right, bounds.top)
    end
    fill_color color
  end
end