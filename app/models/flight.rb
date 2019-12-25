class Flight < ApplicationRecord
  has_many :pilots
  has_many :waypoints

  def full_callsign
    callsign_number.present? ? "#{callsign} #{callsign_number}" : callsign
  end

  def tacan
    "#{tacan_channel}#{tacan_polarization}"
  end
end
