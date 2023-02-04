# frozen_string_literal: true

require_relative '../modules/instance_counter'
require_relative '../modules/validator'

# class Route
class Route
  include InstanceCounter
  include Validator

  attr_reader :start, :finish, :stations

  def initialize(start, finish)
    @start = start
    @finish = finish
    @stations = [start, finish]
    register_instance
    valid?
  end

  def add(station)
    raise 'Станция должна быть экземпляром класса Station' if station.class.name != 'Station'
    raise 'Станция уже присутствует в маршруте' if @stations.include?(station)

    @stations.insert(-2, station)
  end

  def remove(station)
    @stations.delete(station)
  end

  def stations_list
    stations.map(&:name).join('-')
  end

  private

  def validate!
    raise 'Начало маршрута должно быть экземпляром класса Station' if @start.class.name != 'Station'
    raise 'Конец маршрута должен быть экземпляром класса Station' if @finish.class.name != 'Station'
  end
end
