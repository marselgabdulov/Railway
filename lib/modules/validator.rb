# frozen_string_literal: true

# module Validator
module Validator
  protected

  def valid?
    # Предложенный в комментариях к скринкасту вариант в rescue не отлавливает ошибки
    validate! ? true : false
  end
end
