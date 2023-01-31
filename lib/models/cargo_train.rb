# frozen_string_literal: true

require_relative 'train'

# Cargo Train
class CargoTrain < Train
  def initialize(_serial_number)
    super
    @type = 'грузовой'
  end
end
