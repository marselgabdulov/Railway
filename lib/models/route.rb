# frozen_string_literal: true

# Route has initialized first and last stations,
# can add and remove in-between station,
# can show ordered list of stations
class Route
  attr_reader :start, :finish, :stations

  def initialize(start, finish)
    @start = start
    @finish = finish
    @stations = [start, finish]
  end

  def add(station)
    @stations.insert(-2, station)
  end

  def remove(station)
    @stations.delete(station)
  end

  def stations_list
    @stations.map(&:name).join('-')
  end
end
