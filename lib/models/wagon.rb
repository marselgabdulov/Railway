# frozen_string_literal: true

require 'securerandom'

require_relative '../modules/producer'

# class Wagon
class Wagon
  attr_reader :type, :serial_number

  include Producer

  def initialize
    @serial_number = SecureRandom.alphanumeric(5)
  end
end
