# frozen_string_literal: true

require_relative '../../lib/models/train'
require_relative '../../lib/models/passenger_train'
require_relative '../../lib/models/cargo_wagon'
require_relative '../../lib/models/passenger_wagon'

describe PassengerTrain do
  before(:each) do
    @passenger_train = PassengerTrain.new('PT1-11')
    @passenger_wagon = PassengerWagon.new
    @cargo_wagon = CargoWagon.new
  end

  context '#add_wagon' do
    it 'adds wagon' do
      @passenger_train.add_wagon(@passenger_wagon)

      expect(@passenger_train.wagons.length).to eq(1)
    end

    it 'rases wrong type of wagon' do
      expect do
        @passenger_train.add_wagon(@cargo_wagon)
      end.to raise_error(RuntimeError, 'Нельзя добавить вагон другого типа')
    end
  end

  context '#remove_wagon' do
    it 'raises error on moving' do
      @passenger_train.send(:add_wagon, @passenger_wagon)
      @passenger_train.accelerate(50)

      expect do
        @passenger_train.send(:remove_wagon)
      end.to raise_error(RuntimeError, 'Поезд в движении. Операция невозможна')
    end
  end
end
