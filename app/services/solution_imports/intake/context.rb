# frozen_string_literal: true

module SolutionImports
  module Intake
    class Context < SolutionImports::AbstractContext
      include ProcessesCSVRows

      provider_required false

      strategy "intake"

      solution_kind :intake
    end
  end
end
