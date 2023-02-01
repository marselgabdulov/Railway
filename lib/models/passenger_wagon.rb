# frozen_string_literal: true

require_relative 'wagon'

# Passenger Wagon
class PassengerWagon < Wagon
  def initialize
    super
    @type = 'пассажирский'
  end
end
