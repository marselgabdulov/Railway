# frozen_string_literal: true

require_relative '../../lib/models/train'
require_relative '../../lib/models/station'
require_relative '../../lib/models/route'
require_relative '../../lib/models/cargo_wagon'

describe Train do
  before(:each) do
    @train = Train.new('001-11')
    @station_one = Station.new('Москва')
    @station_two = Station.new('Петушки')
    @station_three = Station.new('Кусково')
    @station_four = Station.new('Ольгино')
    route = Route.new(@station_one, @station_two)
    route.add(@station_three)
    route.add(@station_four)
    @wagon = CargoWagon.new

    @train.accept_route(route)
  end

  context '#valid_serial_number?' do
    it 'check valid serial number' do
      expect(@train.send(:valid_serial_number?, 'ОПТ-12')).to be_truthy
    end

    it 'check invalid serial number' do
      expect(@train.send(:valid_serial_number?, 'ОПТ-121')).to be_falsy
    end
  end

  context '#self.find' do
    it 'finds existing instance' do
      train = Train.new('911-11')

      expect(Train.find('911-11')).to eq(train)
    end

    it 'returns nil to unexisting instance' do
      expect(Train.find('874-84')).to eq(nil)
    end
  end

  context '#accept_route' do
    it 'accepts new route' do
      route = Route.new(@station_two, @station_one)
      @train.accept_route(route)

      expect(@train.current_station).to eq(@station_two)
    end

    it 'raises error if route not accepted' do
      @train.route = nil

      expect { @train.current_station }.to raise_error(RuntimeError, 'Маршрут не задан')
    end
  end

  it '#next_station' do
    @train.forward

    expect(@train.next_station).to eq(@station_four)
  end

  it '#previos_station' do
    @train.forward

    expect(@train.previous_station).to eq(@station_one)
  end

  context '#forward' do
    it 'moves to the next station' do
      2.times { @train.forward }

      expect(@train.current_station).to eq(@station_four)
    end

    it 'raises error if on finish' do
      3.times { @train.forward }

      expect { @train.forward }.to raise_error(RuntimeError, 'Движение вперед невозможно')
    end

    it 'raises nil route error' do
      @train.route = nil

      expect { @train.forward }.to raise_error(RuntimeError, 'Маршрут не задан')
    end
  end

  context '#backward' do
    it 'moves to the previous station' do
      2.times { @train.forward }
      @train.backward

      expect(@train.current_station).to eq(@station_three)
    end

    it 'raises error if on start' do
      expect { @train.backward }.to raise_error(RuntimeError, 'Движение назад невозможно')
    end
  end

  it '#accelerate' do
    @train.accelerate(50)

    expect(@train.speed).to eq(50)
  end

  it '#brake' do
    @train.brake

    expect(@train.speed).to eq(0)
  end

  context '#add_wagon' do
    it 'raises moving error' do
      @train.accelerate(50)

      expect { @train.send(:add_wagon, @wagon) }.to raise_error(RuntimeError, 'Поезд в движении. Операция невозможна')
    end
  end

  context '#remove_wagon' do
    it 'raises empty train error' do
      expect do
        @train.send(:remove_wagon)
      end.to raise_error(RuntimeError, 'У поезда отсутствуют вагоны. Операция невозможна')
    end
  end
end
