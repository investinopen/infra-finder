# frozen_string_literal: true

module Solutions
  module Revisions
    module Diffs
      class TimestampDiff < BaseDiff
        diffs! :datetime
      end
    end
  end
end
