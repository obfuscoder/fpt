class Waypoint < ApplicationRecord
  belongs_to :flight

  enum status: %i[dm dms mgrs]

  default_scope { order(:number) }

  before_validation :set_number
  after_destroy :destroyed

  def to_s(type = :dm)
    Position.new(latitude: latitude, longitude: longitude, dme: dme).to_s(type)
  end

  def coords(type = :dm)
    Position.new(latitude: latitude, longitude: longitude, dme: dme).coords(type)
  end

  def position(type = :dm)
    to_s(type)
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
