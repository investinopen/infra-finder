# frozen_string_literal: true

module SolutionImports
  module Legacy
    # Compose multiple values into a standardized implementation interface.
    #
    # @api private
    # @see SolutionImports::Legacy::ImplementationComposer
    class ComposeImplementation < Support::SimpleServiceOperation
      service_klass SolutionImports::Legacy::ImplementationComposer
    end
  end
end
