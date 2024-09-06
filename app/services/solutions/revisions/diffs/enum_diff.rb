# frozen_string_literal: true

module Solutions
  module Revisions
    module Diffs
      class EnumDiff < BaseDiff
        diffs! :string

        UNKNOWN = /\Aunknown\z/i

        def describe(value)
          status_tag(value)
        end

        def has_no_new_value?
          super || UNKNOWN.match?(new_value)
        end
      end
    end
  end
end
