# frozen_string_literal: true

require_relative 'wagon'

# Cargo wagon
class CargoWagon < Wagon
  attr_reader :free_volume, :taken_volume

  def initialize(full_volume)
    super()
    @type = 'грузовой'
    @full_volume = full_volume
    @free_volume = @full_volume
    @taken_volume = 0
  end

  def fill_volume(value)
    raise 'Вместительность вагона недостаточна' if value > @free_volume

    @free_volume -= value
    @taken_volume += value
  end
end
