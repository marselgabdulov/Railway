# frozen_string_literal: true

require_relative '../../lib/modules/instance_counter'
require_relative '../../lib/models/station'

describe InstanceCounter do
  before(:each) do
    # Иначе считаются инстансы из других тестов
    Station.instances = nil
  end

  it 'counts station instances' do
    Station.new('Москва')
    Station.new('Магадан')
    expect(Station.instances).to eq(2)
  end
end
