# frozen_string_literal: true

require_relative '../../lib/models/station'
require_relative '../../lib/models/cargo_train'
require_relative '../../lib/models/passenger_train'

describe Station do
  before(:each) do
    @first_train = PassengerTrain.new('PT-001')
    @second_train = PassengerTrain.new('PT-002')
    @third_train = CargoTrain.new('CT-003')
    @fourth_train = CargoTrain.new('CT-004')

    @station = Station.new('Москва Товарная')

    @station.take(@first_train)
    @station.take(@second_train)
    @station.take(@third_train)
    @station.take(@fourth_train)
  end

  context 'all' do
    it 'returns all instances' do
      station = Station.new('Химки')

      expect(Station.all.last).to eq(station)
    end
  end

  it 'takes the train' do
    train = CargoTrain.new('CT-005')
    @station.take(train)

    expect(@station.trains.length).to eq(5)
  end

  it 'send the train' do
    @station.remove(@fourth_train)

    expect(@station.trains.length).to eq(3)
  end

  it 'filters trains by type' do
    passenger_trains = @station.filter_by_type('пассажирский')

    expect(passenger_trains.length).to eq(2)
  end
end
