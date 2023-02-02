# frozen_string_literal: true

# module InstanceCounter
module InstanceCounter
  # module ClassMethods
  module ClassMethods
    attr_accessor :instances

    # колбэк inherited вызывается при создании дочернего класса
    def inherited(subclass)
      super
      # instance_exec вызывает код в блоке в контексте дочернего класса
      # создаем инстанстную переменную и присваиваем значение 0
      subclass.instance_exec { @instances = 0 }
    end

    def add_instance
      # instances содержит число или nil, приводим все к числу
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
