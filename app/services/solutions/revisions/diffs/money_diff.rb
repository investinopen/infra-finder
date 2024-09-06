# frozen_string_literal: true

module Solutions
  module Revisions
    module Diffs
      class MoneyDiff < BaseDiff
        diffs! ::Solutions::Revisions::MoneyValue.to_type

        # @param [Solutions::Revisions::MoneyValue]
        def describe(value)
          value.to_description
        end

        def has_no_new_value?
          new_value.blank? || new_value.try(:empty?)
        end
      end
    end
  end
end
