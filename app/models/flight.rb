class Flight < ApplicationRecord
  has_many :pilots, -> { order(:number) }
  has_many :waypoints

  default_scope { order(start: :desc) }
  scope :current, -> { where('start > ?', 1.day.ago) }

  def full_callsign
    callsign_number.present? ? "#{callsign} #{callsign_number}" : callsign
  end

  def tacan
    "#{tacan_channel}#{tacan_polarization}"
  end

  def support
    return [] unless self[:support].present?

    self[:support].split(',').map(&:strip)
  end

  def support=(value)
    self[:support] = value.join(',')
  end

  def selected_support
    return [] unless support

    support.map { |s| OpenStruct.new({key: s}.merge Settings.theaters[theater].support[s]) }
  end

  def departure_name
    return unless departure

    Settings.theaters[theater].airbases[start_airbase].departures[departure]
  end

  def recovery_name
    return unless recovery

    Settings.theaters[theater].airbases[land_airbase].recoveries[recovery]
  end

  def divert_name
    return unless divert

    Settings.theaters[theater].airbases[divert_airbase].recoveries[divert]
  end

  def airframes
    "#{slots}x #{Settings.airframes[airframe]}"
  end

  def tacan_channels
    "#{tacan_channel}/#{tacan_channel + 63}"
  end

  def others
    Flight.where(theater: theater, start: (start - 4.hours)..(start + 4.hours)).where.not(id: id)
  end

  def laser_mask
    "#{laser}X"
  end
end
