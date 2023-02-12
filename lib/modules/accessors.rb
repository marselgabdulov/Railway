# frozen_string_literal: true

# module Accessors
module Accessors
  def attr_accessor_with_history(*methods)
    methods.each do |method|
      attr_reader method

      raise TypeError, 'название метода должно быть символом' unless method.is_a?(Symbol)

      define_method("#{method}_history") do
        instance_variable_get("@#{method}_history") || instance_variable_set("@#{method}_history", [nil])
      end

      define_method("#{method}=") do |value|
        history = instance_variable_get("@#{method}_history")
        unless history
          history = []
          history.push(nil)
        end
        instance_variable_set("@#{method}_history", history << value)

        instance_variable_set("@#{method}", value)
      end
    end
  end

  def strong_attr_accessor(method, type)
    attr_reader method

    raise TypeError, 'название метода должно быть символом' unless method.is_a?(Symbol)
    raise TypeError, 'тип должен быть символом' unless type.is_a?(Symbol)

    define_method("#{method}=") do |value|
      raise TypeError, 'неверный тип' unless value.is_a?(Kernel.const_get(type.capitalize))

      instance_variable_set("@#{method}", value)
    end
  end
end
