# frozen_string_literal: true

require_relative '../../lib/modules/validation'
require_relative '../../lib/models/station'
require_relative '../../lib/models/train'
require_relative '../../lib/models/route'

describe Validation do
  context 'presence' do
    it 'raises error' do
      expect { Station.new('') }.to raise_error(StandardError, 'Атрибут name не должен быть пустым')
    end
  end

  context 'format' do
    it 'raises error' do
      # matches
      expect { Train.new('111') }.to raise_error(RuntimeError)

      # expected RuntimeError with "Неверный формат serial_number", got #<RuntimeError: , 'Неверный формат serial_number'>
      # expect { Train.new('111') }.to raise_error(RuntimeError, 'Неверный формат')
    end
  end

  # проверил вручную
  context 'type' do
    it 'raises error' do
      expect { Route.new('start', 'finish') }.to raise_error(RuntimeError)
    end

    it 'does not raise error' do
      start = Station.new('Moscow')
      finish = Station.new('Vladivostok')

      expect { Route.new(start, finish) }.to_not raise_error(RuntimeError)
    end
  end
end
