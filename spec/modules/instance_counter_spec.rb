# frozen_string_literal: true

require_relative '../../lib/modules/instance_counter'
require_relative '../../lib/models/station'
require_relative '../../lib/models/route'

describe InstanceCounter do
  it 'counts route instances' do
    start = Station.new('Москва')
    finish = Station.new('Магадан')
    Route.new(start, finish)
    Route.new(finish, start)

    expect(Route.instances).to eq(2)
  end

  it 'counts station instances' do
    expect(Station.instances).to eq(2)
  end
end
