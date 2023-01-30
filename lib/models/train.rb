# frozen_string_literal: true

# Train
class Train
  attr_reader :speed, :type, :wagons, :serial_number
  attr_writer :route

  def initialize(serial_number)
    @serial_number = serial_number
    @speed = 0
    @route = nil
    @wagons = []
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

  protected

  def add_wagon(wagon)
    raise 'Поезд в движении. Операция невозможна' if @speed.nonzero?

    @wagons << wagon
  end

  def remove_wagon(wagon)
    if @speed.nonzero?
      raise 'Поезд в движении. Операция невозможна'
    elsif @wagons.empty?
      raise 'Вагоны отсутствуют. Операция невозможна'
    else
      @wagons.delete(wagon)
    end
  end
end
