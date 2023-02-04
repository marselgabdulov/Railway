# frozen_string_literal: true

require_relative '../models/station'
require_relative '../models/route'
require_relative '../models/cargo_train'
require_relative '../models/passenger_train'
require_relative '../models/cargo_wagon'
require_relative '../models/passenger_wagon'

# CommandInterface
class CommandInterface
  attr_reader :stations, :trains, :routes

  def initialize
    # Эти переменные нужны для хранения состояния.
    @stations = []
    @trains = []
    @routes = []
  end

  def new_station
    puts 'Введите название станции'
    name = gets.chomp
    station = create_station(name)
    if station.nil?
      puts "Станция '#{name}' уже существует"
    else
      puts "Станция '#{name}' создана"
    end
  end

  def show_stations
    if @stations.empty?
      puts 'Еше не создано ни одной станции'
    else
      p @stations.collect(&:name)
    end
  end

  def show_current_station
    if @stations.empty?
      puts 'Еще не создано ни одной станции'
    else
      puts "Текущая станция '#{@stations.last.name}'"
    end
  end

  def new_train
    puts 'Введите 1 чтобы создать грузовой или что угодно для создания пассажирского'
    type = gets.chomp
    puts 'Введите серийный номер в формате: 3 цифры или буквы, необязятельный дефис, и 2 цифры или буквы.'
    puts 'Например, 001-ПП'
    type == '1' ? create_train('CargoTrain') : create_train('PassengerTrain')
  end

  def show_trains
    p(@trains.collect { |t| "#{t.type} #{t.serial_number}" })
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
    puts "Маршрут '#{start} - #{finish}' построен"
  end

  def show_route
    if @routes.empty?
      puts 'Маршрут не создан'
    else
      puts "Маршрут #{@routes.last.stations_list}"
    end
  end

  def add_to_route
    if @routes.empty?
      puts 'Маршрут не создан'
    else
      puts 'Введите название станции'
      name = gets.chomp
      if find_object(@routes.last.stations, 'name', name).nil?
        station = create_station(name)
        @routes.last.add(station)
        puts "Станция '#{name}' добавлена в маршрут"
      else
        puts "Станция '#{name}' уже присутствует в маршруте"
      end
      puts "Маршрут #{@routes.last.stations_list}"
    end
  end

  def remove_from_route
    if @routes.empty?
      puts 'Маршрут не создан'
    else
      puts 'Введите название станции'
      name = gets.chomp
      if find_object(@routes.last.stations, 'name', name).nil?
        puts "Станции #{name} нет в маршруте"
      else
        @routes.last.remove(find_object(@stations, 'name', name))
        puts "Станция #{name} удалена из маршрута"
      end
      puts "Маршрут #{@routes.last.stations_list}"
    end
  end

  def route_to_train
    if @routes.empty? && @trains.empty?
      puts 'Не созданы ни маршрут, ни поезд'
    elsif @routes.empty?
      puts 'Не создан маршрут'
    elsif @trains.empty?
      puts 'Не создан поезд'
    else
      @trains.last.accept_route(@routes.last)
      puts "Поезду #{@trains.last.serial_number} назначен маршрут #{@routes.last.stations_list}"
    end
  end

  def train_forward
    if @routes.last.nil? && @trains.last.nil?
      puts 'Не созданы ни маршрут, ни поезд'
    elsif @routes.last.nil?
      puts 'Не создан маршрут'
    elsif @trains.last.nil?
      puts 'Не создан поезд'
    elsif @trains.last.route.nil?
      puts "Поезду #{@trains.last.serial_number} не назначен маршрут"
    else
      begin
        @trains.last.forward
        @trains.last.previous_station.remove(@trains.last)
        @trains.last.current_station.take(@trains.last)
      rescue RuntimeError => e
        puts e.message
      ensure
        puts "Поезд номер #{@trains.last.serial_number} находится на станции #{@routes.last.stations[@trains.last.current_station_index].name}"
      end
    end
  end

  def train_backward
    if @routes.last.nil? && @trains.last.nil?
      puts 'Не созданы ни маршрут, ни поезд'
    elsif @routes.last.nil?
      puts 'Не создан маршрут'
    elsif @trains.last.nil?
      puts 'Не создан поезд'
    elsif @trains.last.route.nil?
      puts "Поезду #{@trains.last.serial_number} не назначен маршрут"
    else
      begin
        @trains.last.backward
        @trains.last.next_station.remove(@trains.last)
        @trains.last.current_station.take(@trains.last)
      rescue RuntimeError => e
        puts e.message
      ensure
        puts "Поезд номер #{@trains.last.serial_number} находится на станции #{@routes.last.stations[@trains.last.current_station_index].name}"
      end
    end
  end

  def add_wagon
    if @trains.empty?
      puts 'Нельзя прицепить вагон к несуществующему поезду'
    else
      if @trains.last.type == 'грузовой'
        @trains.last.add_wagon(CargoWagon.new)
      else
        @trains.last.add_wagon(PassengerWagon.new)
      end
      puts "Вагон прицеплен к поезду #{@trains.last.serial_number}"
    end
  end

  def remove_wagon
    if @trains.empty?
      puts 'Нельзя отцепить вагон от несуществующего поезда'
    else
      begin
        @trains.last.remove_wagon
        puts 'Вагон отцеплен'
      rescue RuntimeError => e
        puts e.message
      end
    end
  end

  def instruction
    puts "Программа имитирует работу железной дороги. Можно создавать ж/д станции, маршруты, поезда и вагоны (грузовые и пассажирские), выбирать поезд для последующих манипуляций, назначать маршруты поездам, прицеплять и отцеплять вагоны, перемещать поезда вперед и назад по маршруту, выводить список поездов на станции и список станций на маршруте следования.

    Комманды:
    - 'новая станция' - создание новой станции
    - 'новый поезд' - создание нового поезда
    - 'новый маршрут' - создать маршрут
    - 'добавить в маршрут' - добавить станцию маршрут
    - 'удалить из маршрута' - удалить станцию из маршрута
    - 'показать маршрут'
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
    puts "На станции '#{@stations.last.name}'"
    p "Грузовые: #{@stations.last.trains.filter { |t| t.type == 'грузовой' }.collect(&:serial_number)}"
    p "Пассажирские: #{@stations.last.trains.filter { |t| t.type == 'пассажирский' }.collect(&:serial_number)}"
  end

  def create_station(name)
    return unless find_object(@stations, 'name', name).nil?

    begin
      station = Station.new(name)
      @stations << station
    rescue RuntimeError => e
      puts e.message
    end
  end

  def create_train(type)
    while (serial_number = gets.chomp)
      if find_object(@trains, 'serial_number', serial_number).nil?
        begin
          train = Kernel.const_get(type).new(serial_number)
          @trains << train
          puts "Поезд #{serial_number} создан"
          break
        rescue RuntimeError => e
          puts e.message
          puts 'Введите серийный номер в формате ХХХ-ХХ'
        end
      else
        puts 'Поезд с таким серийным номером уже существует'
      end
    end
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
