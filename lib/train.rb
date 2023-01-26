# frozen_string_literal: true

# Train has initialized serial number, type and number of wagons.
# Train can accelerate, return current speed, brake (stop),
# return number of wagons, add/remove wagons one by one (only on stop)
# Accepts the route.
# On acception the Route, train moves to the first station of route.
# Train can moves between stations along the route forward and backward by one
# station per step.
# Shows previous, current and next stations on the route.

# TODO заменить объект current_station на current_station_index и попровить тесты
class Train
  attr_reader :speed, :number_of_wagons, :type
  attr_writer :route

  def initialize(serial_number, type, number_of_wagons)
    @serial_number = serial_number
    @type = type
    @number_of_wagons = number_of_wagons
    @speed = 0
    @route = nil
    @current_station_index = nil
  end

  def accept_route(route)
    @route = route
    @current_station_index = 0
  end

  def next_station
    raise 'Маршрут не задан' if @route.nil?

    @route.stations[@current_station_index + 1]
  end

  def current_station
    raise 'Маршрут не задан' if @route.nil?

    @route.stations[@current_station_index]
  end

  def previous_station
    raise 'Маршрут не задан' if @route.nil?

    @route.stations[@current_station_index - 1]
  end

  def forward
    raise 'Движение вперед невозможно' if @current_station_index == @route.stations.length - 1

    @current_station_index += 1
  end

  def backward
    raise 'Движение назад невозможно' if @current_station_index.zero?

    @current_station_index -= 1
  end

  def accelerate(speed)
    @speed = speed
  end

  def brake
    @speed = 0
  end

  def add_wagon
    raise 'Поезд в движении. Операция невозможна' if @speed.nonzero?

    @number_of_wagons += 1
  end

  def remove_wagon
    if @speed.nonzero?
      raise 'Поезд в движении. Операция невозможна'
    elsif @number_of_wagons.zero?
      raise 'Вагоны отсутствуют. Операция невозможна'
    else
      @number_of_wagons -= 1
    end
  end
end
