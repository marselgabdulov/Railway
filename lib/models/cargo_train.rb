# frozen_string_literal: true

require_relative 'train'
require_relative '../modules/validation'


# Cargo Train
class CargoTrain < Train
  include Validation

  validate :serial_number, :presence
  validate :serial_number, :format, SN_PATTERN

  def initialize(_serial_number)
    super
    @type = 'грузовой'
  end
end
