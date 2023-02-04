# frozen_string_literal: true

require_relative '../modules/instance_counter'
require_relative '../modules/validator'

# class Station
class Station
  include InstanceCounter
  include Validator

  attr_reader :name, :trains

  @@stations = []

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
    register_instance
    valid?
  end

  def take(train)
    valid_classes = %w[Train CargoTrain PassengerTrain]
    unless valid_classes.include?(train.class.name)
      raise 'Поезд должен быть экземпляром класса Train, CargoTrain или PassengerTrain'
    end

    @trains << train
  end

  def remove(train)
    @trains.delete(train)
  end

  def filter_by_type(type)
    @trains.filter { |train| train.type == type }
  end

  def self.all
    @@stations
  end

  private

  def validate!
    raise 'Наименование станции должно быть строкой' unless @name.instance_of?(::String)
  end
end
