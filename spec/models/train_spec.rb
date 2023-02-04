# frozen_string_literal: true

require_relative '../../lib/models/train'
require_relative '../../lib/models/route'
require_relative '../../lib/models/cargo_wagon'

describe Train do
  before(:each) do
    @train = Train.new('001-11')
    route = Route.new('Москва', 'Петушки')
    route.add('Кусково')
    route.add('Ольгино')
    @wagon = CargoWagon.new

    @train.accept_route(route)
  end

  context 'serial number validation' do
    it 'check valid serial number' do
      expect(@train.send(:valid_serial_number?, 'ОПТ-12')).to be_truthy
    end

    it 'check invalid serial number' do
      expect(@train.send(:valid_serial_number?, 'ОПТ-121')).to be_falsy
    end
  end

  context 'find method' do
    it 'finds existing instance' do
      train = Train.new('911-11')

      expect(Train.find('911-11')).to eq(train)
    end

    it 'returns nil to unexisting instance' do
      expect(Train.find('874-84')).to eq(nil)
    end
  end

  context 'route' do
    it 'accepts new route' do
      route = Route.new('Химки', 'Москва')
      @train.accept_route(route)

      expect(@train.current_station).to eq('Химки')
    end

    it 'raises error if route not accepted' do
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
    it 'raises moving error' do
      @train.accelerate(50)

      expect { @train.send(:add_wagon, @wagon) }.to raise_error(RuntimeError, 'Поезд в движении. Операция невозможна')
    end
  end

  context 'remove wagon' do
    it 'raises empty train error' do
      expect do
        @train.send(:remove_wagon)
      end.to raise_error(RuntimeError, 'У поезда отсутствуют вагоны. Операция невозможна')
    end
  end
end
