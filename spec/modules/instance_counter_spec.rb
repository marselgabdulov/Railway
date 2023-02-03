# frozen_string_literal: true

require_relative '../../lib/modules/instance_counter'
require_relative '../../lib/models/station'
require_relative '../../lib/models/route'
require_relative '../../lib/models/cargo_train'
require_relative '../../lib/models/passenger_train'
require_relative '../../lib/models/train'

describe InstanceCounter do
  before(:each) do
    # Иначе считаются инстансы из других тестов
    Station.instances = nil
    Route.instances = nil
    CargoTrain.instances = nil
    PassengerTrain.instances = nil
    Train.instances = nil
  end

  it 'counts route instances' do
    start = Station.new('Москва')
    finish = Station.new('Магадан')
    Route.new(start, finish)
    Route.new(finish, start)

    expect(Route.instances).to eq(2)
  end

  it 'counts station instances' do
    Station.new('Москва')
    Station.new('Магадан')
    expect(Station.instances).to eq(2)
  end

  context 'trains' do
    it 'counts cargo trains' do
      CargoTrain.new('cargo-001')

      expect(CargoTrain.instances).to eq(1)
    end

    it 'counts passenger trains' do
      PassengerTrain.new('passenger-001')
      PassengerTrain.new('passenger-002')

      expect(PassengerTrain.instances).to eq(2)
    end

    it 'doesn count parent class instances' do
      expect(Train.instances).to eq(nil)
    end
  end
end
