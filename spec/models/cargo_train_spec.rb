# frozen_string_literal: true

require_relative '../../lib/models/train'
require_relative '../../lib/models/cargo_train'
require_relative '../../lib/models/cargo_wagon'
require_relative '../../lib/models/passenger_wagon'

describe CargoTrain do
  before(:each) do
    @cargo_train = CargoTrain.new('CT0-11')
    @cargo_wagon = CargoWagon.new(100)
    @passenger_wagon = PassengerWagon.new(30)
  end

  context '#add_wagon' do
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

  context '#remove_wagon' do
    it 'raises error on moving' do
      @cargo_train.send(:add_wagon, @cargo_wagon)
      @cargo_train.accelerate(50)

      expect do
        @cargo_train.send(:remove_wagon)
      end.to raise_error(RuntimeError, 'Поезд в движении. Операция невозможна')
    end
  end

  context '#each_wagon' do
    it 'returns each wagon type' do
      wagon = CargoWagon.new(100)
      @cargo_train.add_wagon(@cargo_wagon)
      @cargo_train.add_wagon(wagon)

      expect(@cargo_train.each_wagon(&:type)).to eq([@cargo_wagon.type, 'грузовой'])
    end
  end
end
