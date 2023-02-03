# frozen_string_literal: true

require_relative '../modules/instance_counter'

# class Route
class Route
  include InstanceCounter

  attr_reader :start, :finish, :stations

  def initialize(start, finish)
    @start = start
    @finish = finish
    @stations = [start, finish]
    register_instance
  end

  def add(station)
    @stations.insert(-2, station)
  end

  def remove(station)
    @stations.delete(station)
  end

  def stations_list
    stations.map(&:name).join('-')
  end
end
