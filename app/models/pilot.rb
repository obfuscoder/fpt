class Pilot < ApplicationRecord
  belongs_to :flight

  def dash_number
    "-#{number}"
  end

  def callsign
    flight.full_callsign + dash_number
  end

  def own_id
    format('%02d', number)
  end

  def net_id
    format('%02d/%02d', flight.group_id, number)
  end

  def laser
    (flight.laser * 10 + number).to_s
  end

  def tacan
    second_polarization = flight.tacan_polarization == 'X' ? 'Y' : 'X'
    case number
    when 1
      flight.tacan
    when 2
      "#{flight.tacan_channel + 63}#{flight.tacan_polarization}"
    when 3
      "#{flight.tacan_channel + 63}#{second_polarization}"
    when 4
      "#{flight.tacan_channel}#{second_polarization}"
    end
  end
end
