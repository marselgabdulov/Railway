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
    puts 'Введите название станции.'
    name = gets.chomp
    station = create_station(name)
    if station.nil?
      puts "Станция #{name} уже существует"
    else
      puts "Станция #{name} создана"
    end
  end

  def new_train
    puts 'Введите категорию поезда (грузовой или пассажирский) и серийный номер. Например, грузовой 001.'
    input = gets.chomp.split
    type = input[0]
    serial_number = input[1]
    train = create_train(type, serial_number)
    if train.nil?
      puts "Поезд #{serial_number} уже существует"
    else
      puts "Поезд #{serial_number} создан"
    end
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

  def create_station(name)
    return unless find_object(@stations, 'name', name).nil?

    station = Station.new(name)
    @stations << station
    station
  end

  def create_train(type, serial_number)
    return unless find_object(@trains, 'serial_number', serial_number).nil?
    train = if type == 'грузовой'
              CargoTrain.new(serial_number)
            else
              PassengerTrain.new(serial_number)
            end
    @trains << train
    train
  end

  def find_object(where, attribute, value)
    where.select { |i| i.method(attribute).call == value }.first
  end
end
