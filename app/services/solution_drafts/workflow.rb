# frozen_string_literal: true

module SolutionDrafts
  class Workflow < Support::WritableStruct
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations

    attribute? :memo, Types::Coercible::String.optional

    def persisted?
      false
    end
  end
end
