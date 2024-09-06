# frozen_string_literal: true

module Solutions
  module Revisions
    module Diffs
      class BooleanDiff < BaseDiff
        diffs! :boolean

        def has_no_new_value?
          new_value.nil?
        end
      end
    end
  end
end
