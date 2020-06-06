class MissionDataCard < Prawn::Document
  INCHES_PER_MM = 0.0393701

  def initialize(flight, options = {})
    page_size = [137.0 * 72 * INCHES_PER_MM, 210.0 * 72 * INCHES_PER_MM]
    super(options.merge(page_layout: :portrait, page_size: page_size, margin: 10))

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
    loadout
    airbases
    start_new_page
    flight_plan
    comms
    start_new_page
    notes
    start_new_page
    support
    start_new_page
    other_flights
    start_new_page
    channels
    start_new_page
    auth
    start_new_page
    navaids
    super
  end

  private

  def flight_info
    define_columns 4

    header("MISSION DATA CARD")

    cell(0, 'OPORD', header: true)
    cell(1, 'Callsign', header: true)
    cell(2, 'Mission', header: true)
    cell(3, 'Date/Time', header: true)
    next_row

    cell(0, @flight.number)
    cell(1, @flight.full_callsign)
    cell(2, @flight.mission)
    cell(3, @flight.start.strftime('%d%H%M%^b%y'))
    next_row

    define_columns 8
    cell(0, 'Task', header: true)
    cell([1, 6], @flight.task)
    cell(7, 'Freq', header: true)
    next_row

    cell(0, 'AO', header: true)
    cell([1, 6], @flight.ao)
    cell(7, @flight.frequency)
    next_row

    define_columns 2
    cell(0, 'Departure', header: true)
    cell(1, 'Recovery', header: true)
    next_row

    cell(0, @flight.departure_name)
    cell(1, @flight.recovery_name)
    next_row

    define_columns 11
    cell(0, '#', header: true)
    cell([1, 5], 'Callsign', header: true)
    cell([4, 6], 'Pilot', header: true)
    cell(7, 'IFF', header: true)
    cell(8, 'TCN', header: true)
    cell(9, 'LSR', header: true)
    cell(10, 'NET', header: true)
    next_row

    @flight.pilots.each do |pilot|
      cell(0, pilot.dash_number)
      cell([1, 5], pilot.callsign)
      cell([4, 6], pilot.name)
      cell(7, pilot.iff)
      cell(8, pilot.tacan)
      cell(9, pilot.laser)
      cell(10, pilot.net_id)
      next_row
    end
    next_row
  end

  def loadout
    l = @flight.parsed_loadout
    define_columns 12
    header('LOADOUT')
    cell(0, 'A/A', header: true)
    cell([1, 8], l.a2a(text: :short))
    cell(9, 'GUN', header: true)
    cell([10, 11], l.gun)
    next_row

    cell(0, 'A/G', header: true)
    cell([1, 8], l.a2g(text: :short))
    cell(9, 'CHF', header: true)
    cell([10, 11], l.chaff)
    next_row

    cell(0, 'POD', header: true)
    cell([1, 8], l.pods(text: :short))
    cell(9, 'FLR', header: true)
    cell([10, 11], l.flares)
    next_row

    cell(0, 'TKS', header: true)
    cell([1, 8], l.tanks(text: :short))
    cell(9, 'FUEL', header: true)
    cell([10, 11], l.fuel)
    next_row

    next_row
  end

  def other_flights
    flights = @flight.others
    return if flights.empty?

    define_columns 10
    header('OTHER FLIGHTS')

    cell([0, 1], 'Callsign', header: true)
    cell([2, 3], 'Mission', header: true)
    cell([4, 5], 'Airframe', header: true)
    cell(6, 'Freq', header: true)
    cell(7, 'TCN', header: true)
    cell(8, 'GrpId', header: true)
    cell(9, 'Laser', header: true)
    next_row

    flights.each do |flight|
      cell([0, 1], flight.full_callsign)
      cell([2, 3], flight.mission)
      cell([4, 5], flight.airframes)
      cell(6, flight.frequency)
      cell(7, flight.tacan_channels)
      cell(8, flight.group_id)
      cell(9, flight.laser_mask)
      next_row

      cell(1, 'AO', header: true)
      cell([2, 4], flight.ao)
      cell(5, 'Task', header: true)
      cell([6, 9], flight.task)
      next_row
    end
    next_row
  end

  def support
    support = @flight.selected_support
    return if support.empty?

    header('SUPPORT')

    tanker = support.select { |s| s.type == 'TANKER' }
    unless tanker.empty?
      define_columns 6
      header('Tanker')
      cell([0, 1], 'Callsign', header: true)
      cell(2, 'TCN', header: true)
      cell(3, 'Freq', header: true)
      cell(4, 'ALT', header: true)
      cell(5, 'TAS', header: true)
      next_row

      tanker.each do |t|
        cell([0, 1], t.callsign)
        cell(2, t.tacan)
        cell(3, t.comms)
        cell(4, t.altitude)
        cell(5, t.speed)
        next_row
        cell(1, 'Pos', header: true)
        cell([2, 5], t.position)
        next_row
      end
    end

    awacs = support.select { |s| s.type == 'AWACS' }
    unless awacs.empty?
      define_columns 10
      header('AWACS')
      cell([0, 1], 'Callsign', header: true)
      cell(2, 'Freq', header: true)
      cell(3, 'ALT', header: true)
      cell([4, 9], 'Pos', header: true)
      next_row

      awacs.each do |a|
        cell([0, 1], a.callsign)
        cell(2, a.comms)
        cell(3, a.altitude)
        cell([4, 9], a.position)
        next_row
      end
    end

    fac = support.select { |s| s.type == 'FAC' }
    unless fac.empty?
      define_columns 10
      header('FAC')
      cell([0, 1], 'Callsign', header: true)
      cell(2, 'Freq', header: true)
      cell(3, 'Elev', header: true)
      cell([4, 9], 'Pos', header: true)
      next_row

      fac.each do |f|
        cell([0, 1], f.callsign)
        cell(2, f.comms)
        cell(3, f.altitude)
        cell([4, 9], f.position)
        next_row
      end
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
    cell(9, 'ALT', header: true)
    cell(10, 'TOT', header: true)
    next_row

    @flight.waypoints.each do |wp|
      cell(0, wp.number)
      cell([1, 2], wp.name)
      cell([3, 8], wp.position)
      cell(9, wp.elevation)
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
    cell(6, 'GND', header: true)
    cell(7, 'TWR', header: true)
    cell(8, 'RWY', header: true)
    cell(9, 'Elev', header: true)
    cell(10, 'ILS', header: true)
    next_row

    if @flight.start_airbase
      airbase = Settings.theaters[@flight.theater].airbases[@flight.start_airbase]
      airbase_line(airbase, 'Dep')
    end
    if @flight.land_airbase
      airbase = Settings.theaters[@flight.theater].airbases[@flight.land_airbase]
      airbase_line(airbase, 'Arr') if airbase
    end
    if @flight.divert_airbase
      airbase = Settings.theaters[@flight.theater].airbases[@flight.divert_airbase]
      airbase_line(airbase, 'Div')
    end
    next_row
  end

  def airbase_line(airbase, type)
    cell(0, type)
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

  def channels
    define_columns 6
    header('RADIO CHANNELS')

    cell(0, '#', header: true)
    cell(1, 'Freq', header: true)
    cell([2, 5], 'Name', header: true)
    next_row

    channels = Settings.theaters[@flight.theater].channels
    channels.each_with_index do |channel, i|
      cell(0, i + 1)
      cell(1, channel.freq)
      cell([2, 5], channel.name)
      next_row
    end
  end

  def auth
    ramrod
    next_row
    code_table
  end

  def ramrod
    define_columns 10
    header('RAMROD')
    crypto = Crypto.new @flight.start.to_date
    0.upto(9).each { |i| cell(i, i, header: true, align: :center) }
    next_row
    crypto.ramrod.chars.each_with_index { |c, i| cell(i, c, align: :center) }
  end

  def code_table
    crypto = Crypto.new @flight.start.to_date
    define_columns 12
    header('KTC 1400 C')
    dryad = crypto.dryad
    cell(0, '', header: true)
    0.upto(9).each { |i| cell(i.zero? ? [1, 2] : i + 2, i, header: true, align: :center) }
    next_row
    dryad.rows.each do |row|
      cell(0, row.header, header: true, align: :center)
      row.columns.each_with_index { |c, i| cell(i.zero? ? [1, 2] : i + 2, c, align: :center) }
      next_row
    end
  end

  def navaids
    define_columns 6
    header('NAVAIDS')

    cell(0, 'Id', header: true)
    cell(1, 'Name', header: true)
    cell(2, 'Channel', header: true)
    cell([3, 4], 'Position', header: true)
    cell(5, 'Elevation', header: true)
    next_row

    navaids = Settings.theaters[@flight.theater].navaids
    navaids.each do |navaid|
      cell(0, navaid.id)
      cell(1, navaid.name)
      cell(2, navaid.channel)
      cell([3, 4], navaid.pos)
      cell(5, navaid.elevation)
      next_row
    end
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
    return if @row == 0

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