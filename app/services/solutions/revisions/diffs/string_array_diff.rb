# frozen_string_literal: true

module Solutions
  module Revisions
    module Diffs
      class StringArrayDiff < BaseDiff
        diffs! :string_array, default: []
      end
    end
  end
end
