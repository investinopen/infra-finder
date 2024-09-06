# frozen_string_literal: true

# @abstract
class ApplicationRecord < ActiveRecord::Base
  extend ArelHelpers
  extend DefinesMonadicOperation

  include AssociationHelpers
  include CallsCommonOperation
  include ExposesRansackable
  include LazyOrdering
  include PostgresEnums
  include StoreModelIntrospection
  include WhereMatches

  primary_abstract_class

  class << self
    # @return [Symbol]
    def factory_bot_name
      model_name.singular.to_sym
    end
  end
end
