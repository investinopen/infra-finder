# frozen_string_literal: true

module BooleanEnums
  extend ActiveSupport::Concern

  def accept_boolean_value_for(new_value, truthy:, falsey:, null:)
    case new_value
    when true
      truthy
    when false
      falsey
    when nil
      null
    when Support::Types::Params::Bool
      actual = Support::Types::Params::Bool[new_value]

      accept_boolean_value_for(actual, truthy:, falsey:, null:)
    else
      new_value
    end
  end

  module ClassMethods
    def boolean_enum!(attr, truthy:, falsey:, null: falsey)
      class_eval <<~RUBY, __FILE__, __LINE__ + 1
      def #{attr}=(new_value)
        super(accept_boolean_value_for(new_value, truthy: #{truthy.inspect}, falsey: #{falsey.inspect}, null: #{null.inspect}))
      end
      RUBY
    end
  end
end
