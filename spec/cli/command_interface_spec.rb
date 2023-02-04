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
    @station_three = Station.new('Химки')
    @commands.stations << @station_one
    @commands.stations << @station_two
    @commands.stations << @station_three
    @train_one = PassengerTrain.new('001-12')
    @train_two = CargoTrain.new('002-CT')
    @commands.trains << @train_one
    @commands.trains << @train_two
    @route = Route.new(@station_one, @station_two)
    @commands.routes << @route
  end

  context '#train_forward' do
    it 'moves forward' do
      @commands.send(:route_to_train)
      @commands.send(:train_forward)

      expect(@commands.trains.last.current_station_index).to be(1)
    end
  end

  context '#train_backward' do
    it 'moves backward' do
      @commands.send(:route_to_train)
      @commands.send(:train_forward)
      @commands.send(:train_forward)

      expect(@commands.trains.last.current_station_index).to be(1)
    end
  end

  context '#create_station' do
    it 'creates new station' do
      @commands.send(:create_station, 'Балогое')

      expect(@commands.stations.length).to be(4)
    end

    it 'does not create station with exsisting name' do
      @commands.send(:create_station, 'Москва')

      expect(@commands.stations.length).to be(3)
    end
  end

  context '#create_train' do
    it 'creates new train' do
      subject { @commands.send(:create_train, 'CargoTrain') }
      allow(subject).to receive(:gets).and_return('001-TR')

      expect(@commands.trains.length).equal?(3)
    end

    it 'does not create train with exsisting serial number' do
      subject { @commands.send(:create_train, 'CargoTrain') }
      allow(subject).to receive(:gets).and_return(@train_one.serial_number)

      expect(@commands.trains.length).equal?(2)
    end
  end

  context '#find_object' do
    it 'finds object' do
      expect(@commands.send(:find_object, @commands.stations, 'name', @station_one.name)).to be(@station_one)
    end
  end

end
