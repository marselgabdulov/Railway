# frozen_string_literal: true

require_relative '../models/station'
require_relative '../models/route'
require_relative '../models/cargo_train'
require_relative '../models/passenger_train'
require_relative '../models/cargo_wagon'
require_relative '../models/passenger_wagon'

# CommandInterface
class CommandInterface
  attr_accessor :stations, :trains, :wagons, :routes, :current_train_serial_number, :current_wagon_serial_number,
                :current_route

  def initialize
    @stations = []
    @trains = []
    @wagons = []
    @routes = []
    @current_route = nil
  end


  def new_station
    puts 'Введите название станции'
    name = gets.chomp

  end

  def instruction
    puts "Программа имитирует работу железной дороги. Можно создавать ж/д станции, маршруты, поезда и вагоны (грузовые и пассажирские), выбирать поезд для последующих манипуляций, назначать маршруты поездам, прицеплять и отцеплять вагоны, перемещать поезда вперед и назад по маршруту, выводить список поездов на станции и список станций на маршруте следования.

    Комманды:
    - 'новая станция' - создание новой станции
    - 'выбрать станцию' - выбрать станцию для манипуляций
    - 'новый поезд' - создание нового поезда
    - 'выбрать поезд' - выбрать поезд для манипуляций
    - 'новый маршрут' - создать маршрут
    - 'показать маршрут'
    - 'назначить маршрут' - пустить выбранный поезд по маршруту
    - 'новый вагон' - создать вагон
    - 'выбрать вагон' - выбрать вагон для манипуляций
    - 'прицепить вагон' - прицепить вагон к поезду
    - 'отцепить вагон'
    - 'поезд вперед' - переместить поезд на следующую странцию
    - 'поезд назад' - переместить поезд на предыдущую странцию
    - 'список станций' - показать все станции
    - 'список поездов' - показать все поезда на текущей станции
    - 'помощь' - печать этой инструкции
    - 'выход'"
  end

  def exit_program
    Kernel.exit
  end

  private

  def find_object(where, attribute, value)
    where.select { |i| i.method(attribute).call == value }.first
  end
end
