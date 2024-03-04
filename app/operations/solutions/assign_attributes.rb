# frozen_string_literal: true

module Solutions
  # Assign cloneable attributes for any given {Solution}
  # or {SolutionDraft}.
  #
  # @see Solutions::AttributeAssigner
  class AssignAttributes < Support::SimpleServiceOperation
    service_klass Solutions::AttributeAssigner
  end
end
