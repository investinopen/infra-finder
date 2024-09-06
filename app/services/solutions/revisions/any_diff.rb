# frozen_string_literal: true

module Solutions
  module Revisions
    AnyDiff = StoreModel.one_of do |json|
      property_name = json.fetch("name") do
        json.fetch(:name, "unknown")
      end

      SolutionProperty.diff_klass_for(property_name)
    end
  end
end
