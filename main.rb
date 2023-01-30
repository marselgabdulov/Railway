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
  when 'новый поезд'
    commands.new_train
  when 'помощь'
    commands.instruction
  when 'выход'
    commands.exit_program
  else
    puts 'Неизвестная команда'
  end
end
