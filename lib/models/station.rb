# frozen_string_literal: true

require_relative '../modules/instance_counter'

# class Station
class Station
  extend InstanceCounter::ClassMethods
  include InstanceCounter::InstanceMethods

  attr_reader :name, :trains

  @@stations = []

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
    register_instance
  end

  def take(train)
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
end
