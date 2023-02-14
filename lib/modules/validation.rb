# frozen_string_literal: true

# module Validation
module Validation
  # module ClassMethods
  module ClassMethods
    attr_accessor :validators

    def validate(attribute, type, option = nil)
      @validators ||= []
      validator = [attribute, type, option]
      @validators << validator unless @validators.include?(validator)
    end

    def presence(*args)
      attr_name = args[0]
      attr_value = args[1]
      "Атрибут #{attr_name} не должен быть пустым" if attr_value.nil? || attr_value.to_s.strip.empty?
    end

    def format(*args)
      attr_name = args[0]
      attr_value = args[1]
      target_format = args[2]
      "Неверный формат #{attr_name}" unless attr_value.match(target_format)
    end

    def type(*args)
      attr_name = args[0]
      attr_value = args[1]
      target_type = args[2]
      "#{attr_name} должен быть #{target_type}" unless attr_value.is_a?(target_type)
    end
  end

  # module InstanceMethods
  module InstanceMethods
    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    protected

    def validate!
      errors = []
      self.class.validators.each do |attribute, validation, options|
        attr_name = attribute
        attr_value = instance_variable_get("@#{attribute}")
        errors << self.class.send(validation, attr_name, attr_value, options)
      end
      raise errors.join(', ') if errors.any?
    end
  end

  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end
end
