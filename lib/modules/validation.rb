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
      case type
      when :presence
        presence(attribute)
      end
    end

    def presence(*args)
      attribute = args[0]
      'Атрибут должен быть' if attribute.nil? || attribute.to_s.strip.empty?
    end

    def format(attribute, target_format)
      'Неверный формат' unless attribute.match(target_format)
    end

    def type(attribute, target_type)
      "Атрибут должен быть #{target_type}" unless attribute.is_a?(target_type)
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

    def validate(*args)
      attribute = args[0]
      validation = args[1]
      options = args[2]
      self.class.validate(attribute, validation, options)
    end

    def validate!
      errors = []
      self.class.validators.each do |attribute, validation, options|
        errors << self.class.send(validation, instance_variable_get("@#{attribute}"), options)
      end
      raise errors.join(', ') if errors.any?
    end
  end

  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end
end
