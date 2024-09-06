# frozen_string_literal: true

module Solutions
  module Revisions
    module Diffs
      class StoreModelListDiff < BaseDiff
        diffs! :any_json

        def describe(value)
          case value
          when Array
            len = value.length

            label "#{len} #{'value'.pluralize(len)}"

            status_tag(label)
          else
            # :nocov:
            status_tag("n/a")
            # :nocov:
          end
        end
      end
    end
  end
end
