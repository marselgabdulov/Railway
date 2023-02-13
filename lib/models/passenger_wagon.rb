# frozen_string_literal: true

require_relative 'wagon'
require_relative '../modules/validation'

# Passenger Wagon
class PassengerWagon < Wagon
  include Validation

  attr_reader :free_seats, :taken_seats

  def initialize(all_seats)
    super()
    @type = 'пассажирский'
    @all_seats = all_seats
    @free_seats = @all_seats
    @taken_seats = 0
    validate :all_seats, :presence
    validate!
  end

  def take_seat
    raise 'Нет свободных мест' if @free_seats.zero?

    @free_seats -= 1
    @taken_seats += 1
  end

  private

  def validate!
    raise 'Количество мест должно быть целым числом' unless @all_seats.instance_of?(::Integer)
  end
end
