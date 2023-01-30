# frozen_string_literal: true

# Station has initilized name,
# can take arrived train,
# can send the train,
# shows list of all trains on station,
# shows list of certain trains by type,
class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def take(train)
    @trains << train
  end

  def send(train)
    @trains.delete(train)
  end

  def filter_by_type(type)
    @trains.filter { |train| train.type == type }
  end
end