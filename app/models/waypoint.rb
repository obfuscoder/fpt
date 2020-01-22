class Waypoint < ApplicationRecord
  belongs_to :flight

  enum format: %i[dm dms d utm mgrs]

  default_scope { order(:number) }

  before_validation :set_number
  after_destroy :destroyed

  def to_s
    Position.new(latitude: latitude, longitude: longitude, dme: dme).to_s(format: format || :dm, precision: precision || 3)
  end

  def coords
    Position.new(latitude: latitude, longitude: longitude, dme: dme).coords(format: format || :dm, precision: precision || 3)
  end

  def position
    to_s
  end

  def format
    (self[:format] ||= :dms).to_sym
  end

  def precision
    self[:precision] ||= 3
  end

  private

  def set_number
    self.number ||= flight.waypoints.count + 1
  end

  def destroyed
    successors = flight.waypoints.where('number > ?', number)
    successors.each do |wp|
      wp.update number: wp.number - 1
    end
  end
end
