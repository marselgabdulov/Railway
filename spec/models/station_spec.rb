# frozen_string_literal: true

require_relative '../../lib/models/station'
require_relative '../../lib/models/cargo_train'
require_relative '../../lib/models/passenger_train'

describe Station do
  before(:each) do
    @first_train = PassengerTrain.new('PT0-01')
    @second_train = PassengerTrain.new('PT0-02')
    @third_train = CargoTrain.new('CT0-03')
    @fourth_train = CargoTrain.new('CT0-04')

    @station = Station.new('Москва Товарная')

    @station.take(@first_train)
    @station.take(@second_train)
    @station.take(@third_train)
    @station.take(@fourth_train)
  end

  context '#validate!' do
    it 'raises error' do
      expect { Station.new(123) }.to raise_error(RuntimeError, 'Наименование станции должно быть строкой')
    end
  end

  context '#self.all' do
    it 'returns all instances' do
      station = Station.new('Химки')

      expect(Station.all.last).to eq(station)
    end
  end

  context '#take' do
    it 'takes the train' do
      train = CargoTrain.new('CT9-05')
      @station.take(train)

      expect(@station.trains.length).to eq(5)
    end

    it 'raises error' do
      expect do
        @station.take('поезд')
      end.to raise_error(RuntimeError, 'Поезд должен быть экземпляром класса Train, CargoTrain или PassengerTrain')
    end
  end

  it '#remove' do
    @station.remove(@fourth_train)

    expect(@station.trains.length).to eq(3)
  end

  it '#filter_by_type' do
    passenger_trains = @station.filter_by_type('пассажирский')

    expect(passenger_trains.length).to eq(2)
  end

  context '#each_train' do
    it 'returns each train serial_number' do
      expect(@station.each_train(&:serial_number)).to eq([@first_train, @second_train,
                                                          @third_train, @fourth_train])
    end

    it 'raises error' do
      station = Station.new('Тула')

      expect { station.each_train }.to raise_error(RuntimeError, 'Поездов нет')
    end
  end
end
