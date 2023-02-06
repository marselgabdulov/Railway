# frozen_string_literal: true

require_relative '../../lib/models/cargo_wagon'

describe CargoWagon do
  before(:each) do
    @wagon = CargoWagon.new(100)
    @wagon.fill_volume(50)
  end

  context '#fill_volume' do
    it 'fills volume' do
      expect(@wagon.free_volume).to eq(50)
      expect(@wagon.taken_volume).to eq(50)
    end

    it 'rases error' do
      expect { @wagon.fill_volume(1000) }.to raise_error(RuntimeError, 'Вместительность вагона недостаточна')
    end
  end
end
