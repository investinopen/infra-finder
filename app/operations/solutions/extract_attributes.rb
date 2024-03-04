# frozen_string_literal: true

module Solutions
  # Extract cloneable attributes for any given {Solution}
  # or {SolutionDraft}.
  #
  # @see Solutions::AttributeExtractor
  class ExtractAttributes < Support::SimpleServiceOperation
    service_klass Solutions::AttributeExtractor
  end
end
