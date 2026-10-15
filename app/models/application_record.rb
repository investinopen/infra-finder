# frozen_string_literal: true

# @abstract
class ApplicationRecord < ActiveRecord::Base
  include ExposesRansackable
  include HasEphemeralSystemSlug
  include PostgresEnums
  include VOG::Model

  primary_abstract_class

  class << self
    # @return [Symbol]
    def factory_bot_name
      model_name.singular.to_sym
    end
  end
end
