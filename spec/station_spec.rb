# frozen_string_literal: true

require './station'
require './train'

describe Station do
  before(:each) do
    @first_train = Train.new('001', 'freight', 2)
    @second_train = Train.new('002', 'passanger', 14)
    @third_train = Train.new('003', 'passanger', 10)
    @fourth_train = Train.new('004', 'passanger', 20)
    @fifth_train = Train.new('005', 'freight', 25)

    @station = Station.new('Москва Товарная')

    @station.take(@first_train)
    @station.take(@second_train)
    @station.take(@third_train)
    @station.take(@fourth_train)
    @station.take(@fifth_train)
  end

  it 'takes the train' do
    train = Train.new('006', 'freight', 2)
    @station.take(train)

    expect(@station.trains.length).to eq(6)
  end

  it 'send the train' do
    @station.send(@fifth_train)

    expect(@station.trains.length).to eq(4)
  end

  it 'filters trains by type' do
    passanger_trains = @station.filter_by_type('passanger')

    expect(passanger_trains.length).to eq(3)
  end
end
