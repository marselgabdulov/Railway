# frozen_string_literal: true

require './lib/models/train'
require './lib/models/passenger_train'
require './lib/models/cargo_wagon'
require './lib/models/passenger_wagon'

describe PassengerTrain do
  before(:each) do
    @passenger_train = PassengerTrain.new('PT-001')
    @passenger_wagon = PassengerWagon.new
    @cargo_wagon = CargoWagon.new
  end

  context 'add wagon' do
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
end
