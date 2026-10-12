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
            # simplecov:disable
            status_tag("n/a")
            # simplecov:enable
          end
        end
      end
    end
  end
end
