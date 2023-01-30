# frozen_string_literal: true

require 'rainbow'

require_relative 'lib/cli/command_interface'

require_relative 'lib/models/cargo_train'
require_relative 'lib/models/passenger_train'
require_relative 'lib/models/cargo_wagon'
require_relative 'lib/models/passenger_wagon'
require_relative 'lib/models/station'
require_relative 'lib/models/route'

commands = CommandInterface.new

commands.instruction

while (line = $stdin.gets.rstrip)

  case line
  when 'новая станция'
    commands.new_station
  when 'текущая станция'
    commands.show_current_station
  when 'выбрать станцию'
    commands.choose_station
  when 'новый поезд'
    commands.new_train
  when 'выбрать поезд'
    commands.choose_train
  when 'новый маршрут'
    commands.new_route
  when 'выбрать маршрут'
    commands.choose_route
  when 'показать маршрут'
    commands.show_route
  when 'добавить в маршрут'
    commands.add_to_route
  when 'удалить из маршрута'
    commands.remove_from_route
  when 'маршрут поезду'
    commands.route_to_train
  when 'поезд вперед'
    commands.train_forward
  when 'поезд назад'
    commands.train_backward
  when 'прицепить вагон'
    commands.add_wagon
  when 'отцепить вагон'
    commands.remove_wagon
  when 'новый вагон'
    commands.new_wagon
  when 'список вагонов'
    commands.show_wagons
  when 'список поездов'
    commands.show_trains
  when 'список станций'
    commands.show_stations
  when 'список маршрутов'
    commands.show_routes
  when 'помощь'
    commands.instruction
  when 'выход'
    commands.exit_program
  else
    puts 'Неизвестная команда'
  end
end
