# frozen_string_literal: true

require_relative 'wagon'

# Cargo wagon
class CargoWagon < Wagon
  def initialize
    super
    @type = 'грузовой'
  end
end
