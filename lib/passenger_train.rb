# frozen_string_literal: true

require_relative 'train'

# Passenger Train
class PassengerTrain < Train
  attr_reader :type

  def initialize(_serial_number)
    super
    @type = 'passenger'
  end

  def add_wagon(wagon)
    super
    raise 'Нельзя добить грузовой вагон' if wagon.type != 'passenger'
  end
end
