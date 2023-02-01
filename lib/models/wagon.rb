# frozen_strin_literal :true

require_relative 'producer_module'

# class Wagon
class Wagon
  attr_reader :type

  include Producer
end