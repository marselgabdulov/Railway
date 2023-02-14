# frozen_string_literal: true

require_relative '../modules/instance_counter'
require_relative '../modules/validation'

# class Station
class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains

  validate :name, :presence

  @@stations = []

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@stations << self
    register_instance
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

  def each_train(&block)
    raise 'Поездов нет' if @trains.empty?

    @trains.each(&block)
  end
end
