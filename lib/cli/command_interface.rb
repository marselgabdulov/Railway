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
    @stations = []
    @trains = []
    @routes = []
  end

  def new_station
    puts 'Введите название станции'
    name = gets.chomp
    create_station(name)
  end

  def show_stations
    if @stations.empty?
      puts 'Еще не создано ни одной станции'
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
    if @stations.empty?
      puts 'Сперва создайте станцию'
    else
      puts 'Введите 1 чтобы создать грузовой или что угодно для создания пассажирского'
      type = gets.chomp
      puts 'Введите серийный номер в формате: 3 цифры или буквы, необязятельный дефис, и 2 цифры или буквы.'
      puts 'Например, 001-ПП'
      type == '1' ? create_train('CargoTrain') : create_train('PassengerTrain')
    end
  end

  def show_all_trains
    if @stations.empty?
      puts 'Не создано ни одной станции'
    else
      @stations.each do |station|
        puts "На станции '#{station.name}':"
        begin
          station.each_train do |train|
            puts "#{train.serial_number} #{train.type} вагонов: #{train.wagons.length}"
          end
        rescue RuntimeError => e
          puts e.message
        end
      end
    end
  end

  def wagon_list
    if @trains.empty?
      puts 'Не создано ни одного поезда'
    else
      @stations.each do |s|
        puts "На станции '#{s.name}':"
        s.each_train do |t|
          t.each_wagon do |w|
            if t.type == 'грузовой'
              puts "Вагон номер '#{w.serial_number}', тип #{w.type}, свободно: #{w.free_volume} единиц, занято: #{w.taken_volume} единиц"
            else
              puts "Вагон номер '#{w.serial_number}', тип #{w.type}, свободно: #{w.free_seats} мест, занято: #{w.taken_seats} мест"
            end
          rescue RuntimeError => e
            puts e.message
          end
        rescue RuntimeError => e
          puts e.message
        end
      end
    end
  end

  def fill_wagon
    if @trains.empty?
      puts 'Не создано ни одного поезда'
    elsif @trains.last.wagons.empty?
      puts 'Вагонов еще нет'
    elsif @trains.last.wagons.last.type == 'грузовой'
      fill_cargo_wagon
    else
      fill_passenger_wagon
    end
  end

  def new_route
    puts 'Введите начало машрута'
    start = gets.chomp
    puts 'Введите конец машрута'
    finish = gets.chomp
    start_station = create_station(start)
    finish_station = create_station(finish)
    begin
      route = Route.new(start_station, finish_station)
      @routes << route
      puts "Маршрут '#{start} - #{finish}' построен"
    rescue RuntimeError => e
      puts e.message
    end
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

      station = create_station(name)
      @routes.last.add(station)
      puts "Станция '#{name}' добавлена в маршрут"
      puts "Маршрут #{@routes.last.stations_list}"
    end
  end

  def remove_from_route
    if @routes.empty?
      puts 'Маршрут не создан'
    else
      puts 'Введите название станции'
      name = gets.chomp
      begin
        station = find_object(@routes.last.stations, 'name', name)
        @routes.last.remove(station)
        puts "Станция #{name} удалена из маршрута"
        puts "Маршрут #{@routes.last.stations_list}"
      rescue RuntimeError => e
        puts e.message
        puts "Маршрут #{@routes.last.stations_list}"
      end
    end
  end

  def route_to_train
    train_errors do
      @trains.last.accept_route(@routes.last)
      puts "Поезду #{@trains.last.serial_number} назначен маршрут #{@routes.last.stations_list}"
    end
  end

  def train_forward
    train = @trains.last
    train_errors do
      train.forward
      train.previous_station.remove(train)
      train.current_station.take(train)
      train_position_message
    rescue RuntimeError => e
      puts e.message
    end
  end

  def train_backward
    train = @trains.last
    train_errors do
      train.backward
      train.next_station.remove(train)
      train.current_station.take(train)
      train_position_message
    rescue RuntimeError => e
      puts e.message
    end
  end

  def add_wagon
    if @trains.empty?
      puts 'Нельзя прицепить вагон к несуществующему поезду'
    else
      wagon = @trains.last.type == 'грузовой' ? create_cargo_wagon : create_passenger_wagon
      begin
        @trains.last.add_wagon(wagon)
        puts "Вагон прицеплен к поезду #{@trains.last.serial_number}"
      rescue RuntimeError => e
        puts e.message
      end
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

  def fill_cargo_wagon
    wagon = @trains.last.wagons.last
    puts "В вагоне #{wagon.free_volume} единиц свободного места. Введите количество погружаемого груза"
    while (value = gets.chomp)
      begin
        wagon.fill_volume(value)
        puts "Cвободного места: #{wagon.free_volume} единиц. Занято: #{wagon.taken_volume}"
        break
      rescue RuntimeError => e
        puts e.message
        break
      end
    end
  end

  def fill_passenger_wagon
    wagon = @trains.last.wagons.last
    begin
      wagon.take_seat
      puts "Свободных мест #{wagon.free_seats}, занятых мест #{wagon.taken_seats}"
    rescue RuntimeError => e
      puts e.message
    end
  end

  def train_errors
    if @routes.empty? && @trains.empty?
      puts 'Не созданы ни маршрут, ни поезд'
    elsif @routes.empty?
      puts 'Не создан маршрут'
    elsif @trains.empty?
      puts 'Не создан поезд'
    else
      yield
    end
  end

  def train_position_message
    puts "Поезд номер #{@trains.last.serial_number} находится на станции #{@routes.last.stations[@trains.last.current_station_index].name}"
  end

  def trains_lists
    puts "На станции '#{@stations.last.name}'"
    p "Грузовые: #{@stations.last.trains.filter { |t| t.type == 'грузовой' }.collect(&:serial_number)}"
    p "Пассажирские: #{@stations.last.trains.filter { |t| t.type == 'пассажирский' }.collect(&:serial_number)}"
  end

  def create_station(name)
    if find_object(@stations, 'name', name).nil?
      begin
        station = Station.new(name)
        @stations << station
        puts "Станция '#{name}' создана"
        station
      rescue RuntimeError => e
        puts e.message
      end
    else
      find_object(@stations, 'name', name)
    end
  end

  def create_train(type)
    while (serial_number = gets.chomp)
      if find_object(@trains, 'serial_number', serial_number).nil?
        begin
          train = Kernel.const_get(type).new(serial_number)
          @trains << train
          @stations.last.trains << train
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

  def create_cargo_wagon
    puts 'Введите объем вагона'
    value = gets.chomp.to_f
    wagon = CargoWagon.new(value)
    puts "Грузовой вагон создан, объем: #{value} единиц "
    wagon
  end

  def create_passenger_wagon
    puts 'Введите количество мест'
    seats = gets.chomp.to_i
    wagon = PassengerWagon.new(seats)
    puts "Пассажирский вагон создан, мест: #{seats}"
    wagon
  end

  def find_object(where, attribute, value)
    where.select { |i| i.method(attribute).call == value }.first
  end
end
