# frozen_string_literal: true

require './lib/models/route'
require './lib/models/station'

describe Route do
  before(:each) do
    start = Station.new('Москва')
    finish = Station.new('Петушки')
    @station_one = Station.new('Кусково')
    @station_two = Station.new('Ольгино')
    @route = Route.new(start, finish)
  end

  it 'shows stations' do
    expect(@route.stations_list).to eq(%w[Москва Петушки])
  end

  it 'adds new station' do
    @route.add(@station_one)
    @route.add(@station_two)

    expect(@route.stations.length).to eq(4)
  end

  it 'removes the station' do
    @route.add(@station_one)
    @route.add(@station_two)
    @route.remove(@station_two)

    expect(@route.stations.length).to eq(3)
  end
end
