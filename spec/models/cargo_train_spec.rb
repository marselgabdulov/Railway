# frozen_string_literal: true

require './lib/models/train'
require './lib/models/cargo_train'
require './lib/models/cargo_wagon'
require './lib/models/passenger_wagon'

describe CargoTrain do
  before(:each) do
    @cargo_train = CargoTrain.new('CT-001')
    @cargo_wagon = CargoWagon.new
    @passenger_wagon = PassengerWagon.new
  end

  context 'add wagon' do
    it 'adds wagon' do
      @cargo_train.add_wagon(@cargo_wagon)

      expect(@cargo_train.wagons.length).to eq(1)
    end

    it 'rases wrong type of wagon' do
      expect do
        @cargo_train.add_wagon(@passenger_wagon)
      end.to raise_error(RuntimeError, 'Нельзя добавить вагон другого типа')
    end
  end

  context 'remove wagon' do
    it 'raises error on moving' do
      @cargo_train.send(:add_wagon, @cargo_wagon)
      @cargo_train.accelerate(50)

      expect do
        @cargo_train.send(:remove_wagon)
      end.to raise_error(RuntimeError, 'Поезд в движении. Операция невозможна')
    end
  end
end
