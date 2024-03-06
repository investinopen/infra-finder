# frozen_string_literal: true

module SolutionImports
  # Process a {SolutionImport} into the system.
  #
  # @see SolutionImports::Processor
  class Process < Support::SimpleServiceOperation
    service_klass SolutionImports::Processor
  end
end
