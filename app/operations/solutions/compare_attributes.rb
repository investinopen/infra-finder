# frozen_string_literal: true

module Solutions
  # Compare cloneable attributes for any pair of {Solution} and {SolutionDraft}.
  #
  # @see Solutions::AttributeComparator
  class CompareAttributes < Support::SimpleServiceOperation
    service_klass Solutions::AttributeComparator
  end
end
