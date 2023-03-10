# frozen_string_literal: true

require_relative '../modules/producer'
require_relative '../modules/instance_counter'
require_relative '../modules/validation'
require_relative '../modules/accessors'

# Train
class Train
  include Producer
  include InstanceCounter
  include Validation
  extend Accessors

  attr_reader :speed, :type, :wagons, :serial_number

  attr_accessor_with_history :route, :current_station_index

  SN_PATTERN = /^[a-zA-Zа-яА-Я0-9]{3}(-)?[a-zA-Zа-яА-Я0-9]{2}$/

  validate :serial_number, :presence
  validate :serial_number, :format, SN_PATTERN

  @@trains = []

  def initialize(serial_number)
    @serial_number = serial_number
    @speed = 0
    @route = nil
    @wagons = []
    @current_station_index = nil
    @type = nil
    validate!
    @@trains << self
    register_instance
  end

  def self.find(serial_number)
    @@trains.find { |t| t.serial_number == serial_number }
  end

  def accept_route(route)
    @current_station_index = 0
    @route = route
  end

  def next_station
    no_route_error
    if @current_station_index == @route.stations.length - 1
      @route.stations[@current_station_index]
    else
      @route.stations[@current_station_index + 1]
    end
  end

  def current_station
    no_route_error
    @route.stations[@current_station_index]
  end

  def previous_station
    no_route_error
    if @current_station_index.zero?
      @route.stations[0]
    else
      @route.stations[@current_station_index - 1]
    end
  end

  def forward
    no_route_error
    raise 'Движение вперед невозможно' if @current_station_index == @route.stations.length - 1

    @current_station_index += 1
  end

  def backward
    no_route_error
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

  def each_wagon(&block)
    raise 'Вагонов нет' if @wagons.empty?

    @wagons.each(&block)
  end

  protected

  def no_route_error
    raise 'Маршрут не задан' if @route.nil?
  end
end
