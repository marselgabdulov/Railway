# frozen_string_literal: true

require_relative '../models/station'
require_relative '../models/route'
require_relative '../models/cargo_train'
require_relative '../models/passenger_train'
require_relative '../models/cargo_wagon'
require_relative '../models/passenger_wagon'

# CommandInterface
class CommandInterface
  attr_reader :stations, :trains, :cargo_wagons, :passenger_wagons, :routes, :current_route, :current_train
  attr_accessor :current_station

  def initialize
    @stations = []
    @trains = []
    @cargo_wagons = []
    @passenger_wagons = []
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
      name = gets.chomp
      @current_station = find_object(@stations, 'name', name)
      puts "Текущая станция - #{@current_station.name}"
    end
  end

  def show_current_station
    if @stations.empty?
      puts 'Еще не создано ни одной станции'
    else
      puts "Текущая станция #{@current_station.name}"
    end
  end

  def new_train
    if @current_station.nil?
      puts 'Нельзя создать поезд. Сперва создайте станцию'
    else
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
  end

  def choose_train
    if @trains.empty?
      puts 'Еще не создано ни одного поезда'
    else
      puts 'Выберите поезд из списка и введите серийный номер:'
      show_trains
      serial_number = gets.chomp
      train = find_object(@trains, 'serial_number', serial_number)
      if train.nil?
        puts "Поезда с серийным номером #{serial_number} не существует"
      else
        @current_train = train
        puts "Поезд с серийным номером #{serial_number} готов к манипуляциям"
      end
    end
  end

  def show_trains
    if @current_station.nil?
      puts 'Еще не создано ни одной станции'
    elsif @current_station.trains.empty?
      puts "Поездов на станции '#{@current_station.name}' нет"
    else
      trains_lists
    end
  end

  def new_route
    puts 'Введите начало машрута'
    start = gets.chomp
    puts 'Введите конец машрута'
    finish = gets.chomp
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

  def train_forward
    if @current_route.nil? && @current_train.nil?
      puts 'Не созданы ни маршрут, ни поезд'
    elsif @current_route.nil?
      puts 'Не создан маршрут'
    elsif @current_train.nil?
      puts 'Не создан поезд'
    elsif @current_train.route.nil?
      puts "Поезду #{@current_train.serial_number} не назначен маршрут"
    else
      begin
        @current_train.previous_station.send(@current_train)
        @current_train.forward
      rescue RuntimeError => e
        puts e.message
      ensure
        puts "Поезд номер #{@current_train.serial_number} находится на станции #{@current_route.stations[@current_train.current_station_index].name}"
      end
    end
  end

  def train_backward
    if @current_route.nil? && @current_train.nil?
      puts 'Не созданы ни маршрут, ни поезд'
    elsif @current_route.nil?
      puts 'Не создан маршрут'
    elsif @current_train.nil?
      puts 'Не создан поезд'
    elsif @current_train.route.nil?
      puts "Поезду #{@current_train.serial_number} не назначен маршрут"
    else
      begin
        @current_train.next_station.send(@current_train)
        @current_train.backward
      rescue RuntimeError => e
        puts e.message
      ensure
        puts "Поезд номер #{@current_train.serial_number} находится на станции #{@current_route.stations[@current_train.current_station_index].name}"
      end
    end
  end

  def new_wagon
    puts 'Введите тип вагона (грузовой или пассажирский)'
    type = gets.chomp
    if type == 'грузовой'
      @cargo_wagons << CargoWagon.new
    else
      @passenger_wagons << PassengerWagon.new
    end
    puts 'Вагон создан'
  end

  def show_wagons
    if @cargo_wagons.empty? && @passenger_wagons.empty?
      puts 'Вагонов еще нет'
    else
      p "Грузовых: #{@cargo_wagons.length}"
      p "Пассажирских: #{@passenger_wagons.length}"
    end
  end

  def add_wagon
    if @current_train.nil?
      puts 'Поезд не создан. Не к чему цеплять'
    elsif @current_train.type == 'cargo' && @cargo_wagons.empty? || @current_train.type == 'passenger' && @passenger_wagons.empty?
      puts 'Вагонов нужного типа нет'
    elsif @current_train.type == 'cargo'
      @current_train.add_wagon(@cargo_wagons.pop)
      puts 'Вагон прицеплен'
    else
      @current_train.add_wagon(@passenger_wagons.pop)
      puts 'Вагон прицеплен'
    end
    show_wagons
  end

  def remove_wagon
    if @current_train.nil?
      puts 'Поезд не создан. Не от чего отцеплять'
    elsif @current_train.type == 'cargo'
      last_wagon(@cargo_wagons)
    else
      last_wagon(@passenger_wagons)
    end
    show_wagons
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

  # Методы ниже служебные, поэтому я их закрыл для внешнего доступа
  private

  def trains_lists
    p "Грузовые: #{@current_station.trains.filter { |t| t.type == 'cargo' }.collect(&:serial_number)}"
    p "Пассажирские: #{@current_station.trains.filter { |t| t.type == 'passenger' }.collect(&:serial_number)}"
  end

  def last_wagon(wagons_depo)
    if @current_train.wagons.empty?
      puts 'Вагонов нет'
    else
      wagon = @current_train.wagons.last
      begin
        @current_train.remove_wagon(wagon)
        wagons_depo << wagon
      rescue RuntimeError => e
        puts e.message
      end
    end
  end

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
    @current_station.take(train)
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
