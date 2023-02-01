# frozen_strin_literal :true

require_relative '../modules/producer'

# class Wagon
class Wagon
  attr_reader :type

  include Producer
end