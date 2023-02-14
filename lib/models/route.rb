# frozen_string_literal: true

require_relative '../modules/instance_counter'
require_relative '../modules/validation'

# class Route
class Route
  include InstanceCounter
  include Validation

  attr_reader :start, :finish, :stations

  validate :start, :presence
  validate :finish, :presence
  validate :start, :type, Station
  validate :finish, :type, Station

  def initialize(start, finish)
    @start = start
    @finish = finish
    @stations = [start, finish]
    validate!
    register_instance
  end

  def add(station)
    raise 'Станция должна быть экземпляром класса Station' if station.class.name != 'Station'
    raise 'Станция уже присутствует в маршруте' if @stations.include?(station)

    @stations.insert(-2, station)
  end

  def remove(station)
    raise 'Станции нет в маршруте' unless @stations.include?(station)

    @stations.delete(station)
  end

  def stations_list
    stations.map(&:name).join('-')
  end
end
