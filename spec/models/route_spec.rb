# frozen_string_literal: true

require_relative '../../lib/models/route'
require_relative '../../lib/models/station'

describe Route do
  before(:each) do
    start = Station.new('Москва')
    finish = Station.new('Петушки')
    @station_one = Station.new('Кусково')
    @station_two = Station.new('Ольгино')
    @route = Route.new(start, finish)
    @route.add(@station_one)
  end

  it '#station_list' do
    expect(@route.stations_list).to eq('Москва-Кусково-Петушки')
  end

  context '#add' do
    it 'adds new station' do
      @route.add(@station_two)

      expect(@route.stations.length).to eq(4)
    end

    it 'raises wrong type error' do
      expect { @route.add('Балогое') }.to raise_error(RuntimeError, 'Станция должна быть экземпляром класса Station')
    end

    it 'raises presence error' do
      expect { @route.add(@station_one) }.to raise_error(RuntimeError, 'Станция уже присутствует в маршруте')
    end
  end

  context '#remove' do
    it 'removes' do
      @route.add(@station_two)
      @route.remove(@station_two)

      expect(@route.stations.length).to eq(3)
    end

    it 'raises not exisiting error' do
      expect { @route.remove(@station_two) }.to raise_error(RuntimeError, 'Станции нет в маршруте')
    end
  end
end
