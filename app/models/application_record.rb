# frozen_string_literal: true

# @abstract
class ApplicationRecord < ActiveRecord::Base
  extend ArelHelpers
  extend DefinesMonadicOperation

  include CallsCommonOperation
  include LazyOrdering
  include PostgresEnums
  include StoreModelIntrospection

  primary_abstract_class

  class << self
    # @return [Symbol]
    def factory_bot_name
      model_name.singular.to_sym
    end
  end
end
