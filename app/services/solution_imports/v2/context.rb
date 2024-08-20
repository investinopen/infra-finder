# frozen_string_literal: true

module SolutionImports
  module V2
    class Context < SolutionImports::AbstractContext
      include ProcessesCSVRows

      strategy "v2"
    end
  end
end
