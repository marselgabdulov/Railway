# frozen_string_literal: true

require_relative 'train'

# Passenger Train
class PassengerTrain < Train
  def initialize(_serial_number)
    super
    @type = 'пассажирский'
  end
end
