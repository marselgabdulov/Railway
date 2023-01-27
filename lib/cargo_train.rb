# frozen_string_literal: true

require_relative 'train'

# Cargo Train
class CargoTrain < Train
  attr_reader :type

  def initialize(_serial_number)
    super
    @type = 'cargo'
  end

  def add_wagon(wagon)
    super
    raise 'Нельзя добить пассажирский вагон' if wagon.type != 'cargo'
  end
end
