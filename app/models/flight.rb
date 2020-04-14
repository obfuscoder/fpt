class Flight < ApplicationRecord
  has_many :pilots, -> { order(:number) }, dependent: :destroy
  has_many :waypoints, dependent: :destroy

  scope :ordered, -> { order(start: :asc, callsign: :asc, callsign_number: :asc) }
  scope :current, -> { where('date(start) >= ?', Date.today) }

  validates :start, presence: true
  validates :iff, presence: true, numericality: { only_integer: true, greater_than: 99, less_than: 800 }

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

    support.map do |s|
      entry = Settings.theaters[theater].support[s]
      OpenStruct.new({ key: s }.merge(entry)) if entry.present?
    end.compact
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

  def assignable_pilots
    Settings.pilots - pilots.pluck(:name) - others.map(&:pilots).flatten.map(&:name)
  end
end
