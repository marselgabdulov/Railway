# frozen_string_literal: true

# module InstanceCounter
module InstanceCounter
  # module ClassMethods
  module ClassMethods
    attr_accessor :instances

    def inherited(subclass)
      super
      subclass.instance_eval { @instances = 0 }
    end

    def add_instance
      klass = self
      klass.instances = klass.instances.to_i + 1
    end
  end

  # module InstanceMethods
  module InstanceMethods
    protected

    def register_instance
      self.class.add_instance
    end
  end
end
