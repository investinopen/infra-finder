# frozen_string_literal: true

module SolutionImports
  # @api private
  class BuildContext < Support::SimpleServiceOperation
    service_klass SolutionImports::ContextBuilder
  end
end
