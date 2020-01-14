require 'position'
require 'waypoint'

class ConvertPositionToLatLonDmeInWaypoints < ActiveRecord::Migration[6.0]
  def up
    Waypoint.all.each do |wp|
      pos = Position.new(pos: wp.position)
      wp.update! dme: pos.dme, latitude: pos.latitude, longitude: pos.longitude
    end
  end

  def down
    Waypoint.all.each do |wp|
      pos = Position.new(latitude: wp.latitude, longitude: wp.longitude, dme: wp.dme)
      wp.update! pos: pos.to_s
    end
  end
end
