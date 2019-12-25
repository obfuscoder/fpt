class Waypoint < ApplicationRecord
  belongs_to :flight

  before_validation :set_number
  after_destroy :destroyed

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
