# frozen_string_literal: true

require_relative 'producer_module'

# Train
class Train
  include Producer

  attr_reader :speed, :type, :wagons, :serial_number, :current_station_index
  attr_accessor :route

  @@trains = []

  def initialize(serial_number)
    @serial_number = serial_number
    @speed = 0
    @route = nil
    @wagons = []
    @current_station_index = nil
    @type = nil
    @@trains << self
  end

  def self.find(serial_number)
    @@trains.find { |t| t.serial_number == serial_number }
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

  def add_wagon(wagon)
    raise 'Поезд в движении. Операция невозможна' if @speed.nonzero?
    raise 'Нельзя добавить вагон другого типа' if wagon.type != @type

    @wagons << wagon
  end

  def remove_wagon
    if @speed.nonzero?
      raise 'Поезд в движении. Операция невозможна'
    elsif @wagons.empty?
      raise 'У поезда отсутствуют вагоны. Операция невозможна'
    else
      @wagons.pop
    end
  end
end
