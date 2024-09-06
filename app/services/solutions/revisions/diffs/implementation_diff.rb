# frozen_string_literal: true

module Solutions
  module Revisions
    module Diffs
      class ImplementationDiff < BaseDiff
        diffs! :any_json

        def describe(_value)
          status_tag("cannot show detailed changes", color: :orange)
        end

        def has_no_new_value?
          new_value.blank? || new_value.compact_blank.blank?
        end
      end
    end
  end
end
