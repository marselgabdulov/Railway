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
    @current_station = nil
    @current_train = nil
  end

  def new_station
    puts 'Введите название станции'
    name = gets.chomp
    station = create_station(name)
    if station.nil?
      puts "Станция #{name} уже существует"
    else
      puts "Станция #{name} создана"
    end
  end

  def show_stations
    if @stations.empty?
      puts 'Еше не создано ни одной станции'
    else
      p @stations.collect(&:name)
    end
  end

  def choose_station
    if @stations.empty?
      puts 'Еще не создано ни одной станции'
    else
      puts 'Выберите станцию из списка и введите название:'
      show_stations
      @current_train = find_object(@trains, 'serial_number', serial_number)
    end
  end

  def new_train
    puts 'Введите категорию поезда (грузовой или пассажирский) и серийный номер. Например, грузовой 001'
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

  def choose_train
    if @trains.empty?
      puts 'Еще не создано ни одного поезда'
    else
      puts 'Выберите поезд из списка и введите серийный номер:'
      show_trains
      @current_train = find_object(@trains, 'serial_number', serial_number)
    end
  end

  def show_trains
    if @current_station.nil?
      puts 'Еще не создано ни одной станции'
    elsif @current_station.trains.empty?
      puts "Поездов на станции '#{@current_station.name}' нет"
    else
      p "Грузовые: #{@current_station.trains.collect { |t| t.type == 'cargo' }}"
      p "Пассажиркие: #{@current_station.trains.collect { |t| t.type == 'passenger' }}"
    end
  end

  def new_route
    puts 'Введите начало и конец маршрута. Например, Москва Владивосток'
    input = gets.chomp.split
    start = input[0]
    finish = input[1]
    start_station = create_station(start)
    finish_station = create_station(finish)
    route = Route.new(start_station, finish_station)
    @routes << route
    @current_route = route
    puts "Маршрут '#{start} - #{finish}' построен"
  end

  def show_route
    if @current_route.nil?
      puts 'Маршрут не создан'
    else
      puts "Маршрут #{@current_route.stations.collect(&:name)}"
    end
  end

  def show_routes
    if @routes.empty?
      puts 'Не создано ни одного маршрута'
    else
      p numbered_routes
    end
  end

  def choose_route
    if @routes.empty?
      puts 'Не создано ни одного маршрута'
    else
      p numbered_routes
      puts 'Введите номер маршрута'
      num = gets.chomp.to_i
      @current_route = @routes[num - 1]
      puts "Выбран маршрут #{@current_route.stations_list}"
    end
  end

  def add_to_route
    if @current_route.nil?
      puts 'Маршрут не создан'
    else
      puts 'Введите название станции'
      name = gets.chomp
      if find_object(@current_route.stations, 'name', name).nil?
        station = create_station(name)
        @current_route.add(station)
        puts "Станция '#{name}' добавлена в маршрут"
      else
        puts "Станция '#{name}' уже присутствует в маршруте"
      end
      puts "Маршрут #{@current_route.stations.collect(&:name)}"
    end
  end

  def remove_from_route
    if @current_route.nil?
      puts 'Маршрут не создан'
    else
      puts 'Введите название станции'
      name = gets.chomp
      if find_object(@current_route.stations, 'name', name).nil?
        puts "Станции #{name} нет в маршруте"
      else
        @current_route.remove(find_object(@stations, 'name', name))
        puts "Станция #{name} удалена из маршрута"
      end
      puts "Маршрут #{@current_route.stations.collect(&:name)}"
    end
  end

  def route_to_train
    if @current_route.nil? && @current_train.nil?
      puts 'Не созданы ни маршрут, ни поезд'
    elsif @current_route.nil?
      puts 'Не создан маршрут'
    elsif @current_train.nil?
      puts 'Не создан поезд'
    else
      @current_train.accept_route(@current_route)
      puts "Поезду #{@current_train.serial_number} назначен маршрут #{@current_route.stations_list}"
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
    @current_station = station
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
    @current_train = train
    train
  end

  def find_object(where, attribute, value)
    where.select { |i| i.method(attribute).call == value }.first
  end

  def numbered_routes
    @routes.each_with_index.map do |route, index|
      "#{index + 1}. #{route.stations_list}"
    end
  end
end
