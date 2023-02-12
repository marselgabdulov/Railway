# frozen_string_literal: true

require_relative '../../lib/modules/accessors'
require_relative '../../lib/models/cargo_train'
require_relative '../../lib/models/passenger_train'
require_relative '../../lib/models/station'

describe Accessors do
  before do
    stub_const 'Foo', Class.new
    Foo.class_eval { extend Accessors }
    Foo.class_eval { attr_accessor_with_history :foo }
    Foo.class_eval { strong_attr_accessor :bar, :string }

    @subject = Foo.new
    @another_subject = Foo.new
  end

  context 'reader' do
    it 'gives the latest value' do
      @subject.foo = 1
      @subject.foo = 2

      expect(@subject.foo).to be(2)
    end
  end

  it 'maintains separate values for each object' do
    @subject.foo = 1
    @another_subject.foo = 2

    expect(@subject.foo).to be(1)
  end

  context 'history' do
    it 'initiallys record the value of nil' do
      expect(@subject.foo_history).to eq([nil])
    end

    it 'records new values in the history' do
      @subject.foo = 1
      @subject.foo = 2

      expect(@subject.foo_history).to eq([nil, 1, 2])
    end

    it 'maintains separate histories for each object' do
      @subject.foo = 1
      @another_subject.foo = 2

      expect(@subject.foo_history).to eq([nil, 1])
    end
  end

  context 'strong_attr_accessor' do
    it 'raises type error' do
      expect { @subject.bar = 1 }.to raise_error(TypeError)
    end

    it 'sets value' do
      @subject.bar = 'bar'

      expect(@subject.bar).to eq('bar')
    end
  end
end
