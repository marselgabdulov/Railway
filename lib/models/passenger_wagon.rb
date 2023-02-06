# frozen_string_literal: true

require_relative 'wagon'

# Passenger Wagon
class PassengerWagon < Wagon
  attr_reader :free_seats, :taked_seats

  def initialize(all_seats)
    super()
    @type = 'пассажирский'
    @all_seats = all_seats
    @free_seats = @all_seats
    @taked_seats = 0
  end

  def take_seat
    raise 'Нет свободных мест' if @free_seats.zero?

    @free_seats -= 1
    @taked_seats += 1
  end
end
