# frozen_string_literal: true

require_relative '../../lib/modules/validator'
require_relative '../../lib/models/train'

describe Validator do
  it 'pass validation' do
    expect(Train.new('001-CT').send(:valid?)).to be_truthy
  end

  it 'fails validation' do
    expect do
      Train.new('001-C').send(:valid?)
    end.to raise_error(RuntimeError, 'Введите серийный номер в формате ХХХ-ХХ или ХХХХХ')
  end
end
