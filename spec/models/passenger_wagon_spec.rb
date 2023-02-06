# frozen_string_literal: true

require_relative '../../lib/models/passenger_wagon'

describe PassengerWagon do
  before(:each) do
    @wagon = PassengerWagon.new(30)
  end

  context '#take_seat' do
    it 'takes a seat' do
      @wagon.take_seat

      expect(@wagon.free_seats).to eq(29)
      expect(@wagon.taken_seats).to eq(1)
    end

    it 'rases error' do
      wagon = PassengerWagon.new(1)
      wagon.take_seat

      expect { wagon.take_seat }.to raise_error(RuntimeError, 'Нет свободных мест')
    end
  end
end
