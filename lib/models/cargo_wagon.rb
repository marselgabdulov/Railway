# frozen_string_literal: true

require_relative 'wagon'
require_relative '../modules/validator'

# Cargo wagon
class CargoWagon < Wagon
  include Validator

  attr_reader :free_volume, :taken_volume

  def initialize(full_volume)
    super()
    @type = 'грузовой'
    @full_volume = full_volume.to_f
    @free_volume = @full_volume
    @taken_volume = 0.0
    validate!
  end

  def fill_volume(value)
    value = value.to_f
    raise 'Вагон заполнен' if @free_volume.zero?
    raise 'Вместительность вагона недостаточна' if value > @free_volume

    @free_volume -= value
    @taken_volume += value
  end

  private

  def validate!
    raise 'Объем должен быть числом' if @all_seats.instance_of?(::Integer) || @all_seats.instance_of?(::Float)
  end
end
