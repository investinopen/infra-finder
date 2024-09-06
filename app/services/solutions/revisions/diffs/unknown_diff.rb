# frozen_string_literal: true

module Solutions
  module Revisions
    module Diffs
      class UnknownDiff < BaseDiff
        diffs! :any_json

        def describe(_value)
          status_tag("cannot show detailed changes", color: :orange)
        end
      end
    end
  end
end
