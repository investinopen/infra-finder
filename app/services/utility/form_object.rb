# frozen_string_literal: true

module Utility
  # @abstract
  class FormObject < Support::WritableStruct
    extend ActiveModel::Naming
    extend Dry::Core::ClassAttributes

    include ActiveModel::Conversion
    include ActiveModel::Validations

    defines :persisted, type: Types::Bool

    persisted false

    def persisted? = self.class.persisted
  end
end
