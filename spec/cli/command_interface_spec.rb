# frozen_string_literal: true

require_relative '../../lib/cli/command_interface'

require_relative '../../lib/models/station'
require_relative '../../lib/models/route'
require_relative '../../lib/models/cargo_train'
require_relative '../../lib/models/passenger_train'
require_relative '../../lib/models/cargo_wagon'
require_relative '../../lib/models/passenger_wagon'

describe CommandInterface do
  before(:each) do
    @commands = CommandInterface.new
    @station_one = Station.new('Москва')
    @station_two = Station.new('Тверь')
    @commands.stations << @station_one
    @commands.stations << @station_two
    @train_one = PassengerTrain.new('001')
    @train_two = PassengerTrain.new('002')

    @route = Route.new(@station_one, @station_two)
  end

  context 'find_object' do
    it 'finds object' do
      expect(@commands.send(:find_object, @commands.stations, 'name', @station_one.name)).to be(@station_one)
    end
  end
end
