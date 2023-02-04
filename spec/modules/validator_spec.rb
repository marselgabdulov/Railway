# frozen_string_literal: true

require_relative '../../lib/modules/validator'
require_relative '../../lib/models/train'

describe Validator do
  it 'pass validation' do
    expect(Train.new('001-CT')).to be_truthy
  end

  it 'fails validation' do
    expect { Train.new('001-C') }.to raise_error(RuntimeError, 'Невалидный формат номера')
  end
end
