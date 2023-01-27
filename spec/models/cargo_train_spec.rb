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
      expect { @cargo_train.add_wagon(@passenger_wagon) }.to raise_error(RuntimeError, 'Нельзя добить пассажирский вагон')
    end
  end
end
