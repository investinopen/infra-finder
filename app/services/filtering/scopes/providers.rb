# frozen_string_literal: true

module Filtering
  module Scopes
    # The filtering scope implementation for {Provider}.
    class Providers < Filtering::FilterScope[Provider]
      has_name_search!

      boolean_scope! :with_multiple_solutions do |arg|
        arg.description "Filter to only providers with more than one solution."
      end

      boolean_scope! :without_solutions do |arg|
        arg.description "Filter to only providers with no solutions."
      end

      boolean_scope! :without_editors do |arg|
        arg.description "Filter to only providers with no editors assigned."
      end

      timestamps!
    end
  end
end
