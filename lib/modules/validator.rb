# frozen_string_literal: true

# module Validator
# Для использования нужно добавить модуль, создать в классе метод validate!
# с нужными проверками и вызвать метод valid? в конструкторе класса
module Validator
  protected

  def valid?
    validate!
    true
  rescue
    false
  end
end
