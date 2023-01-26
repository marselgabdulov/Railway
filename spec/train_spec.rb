# frozen_string_literal: true

require './train'
require './route'

describe Train do
  before(:each) do
    @train = Train.new('001', 'freight', 2)
    route = Route.new('Москва', 'Петушки')
    route.add('Кусково')
    route.add('Ольгино')
    @train.accept_route(route)
  end

  context 'route' do
    it 'accepts new route' do
      route = Route.new('Химки', 'Москва')
      @train.accept_route(route)

      expect(@train.current_station).to eq('Химки')
    end

    it 'raises error if rount not accepted' do
      @train.route = nil

      expect { @train.current_station }.to raise_error(RuntimeError, 'Маршрут не задан')
    end

    it 'returns next station' do
      @train.forward

      expect(@train.next_station).to eq('Ольгино')
    end

    it 'returns previos station' do
      @train.forward

      expect(@train.previous_station).to eq('Москва')
    end
  end

  context 'move forward' do
    it 'moves to the next station' do
      2.times { @train.forward }

      expect(@train.current_station).to eq('Ольгино')
    end

    it 'raises error if on finish' do
      3.times { @train.forward }

      expect { @train.forward }.to raise_error(RuntimeError, 'Движение вперед невозможно')
    end
  end

  context 'move backward' do
    it 'moves to the previous station' do
      2.times { @train.forward }
      @train.backward

      expect(@train.current_station).to eq('Кусково')
    end

    it 'raises error if on start' do
      @train.backward

      expect { @train.backward }.to raise_error(RuntimeError, 'Движение назад невозможно')
    end
  end

  it 'accelerates' do
    @train.accelerate(50)

    expect(@train.speed).to eq(50)
  end

  it 'brakes' do
    @train.brake

    expect(@train.speed).to eq(0)
  end

  context 'add wagon' do
    it 'adds wagon' do
      @train.add_wagon

      expect(@train.number_of_wagons).to eq(3)
    end

    it 'raises moving error' do
      @train.accelerate(50)

      expect { @train.add_wagon }.to raise_error(RuntimeError, 'Поезд в движении. Операция невозможна')
    end
  end

  context 'remove wagon' do
    it 'raises moving error' do
      @train.accelerate(50)

      expect { @train.remove_wagon }.to raise_error(RuntimeError, 'Поезд в движении. Операция невозможна')
    end

    it 'raises empty train error' do
      2.times { @train.remove_wagon }

      expect { @train.remove_wagon }.to raise_error(RuntimeError, 'Вагоны отсутствуют. Операция невозможна')
    end

    it 'removes wagon' do
      @train.remove_wagon

      expect(@train.number_of_wagons).to eq(1)
    end
  end
end
