# frozen_string_literal: true

module SolutionImports
  module EOI
    class Context < SolutionImports::AbstractContext
      include ProcessesCSVRows

      strategy "eoi"
    end
  end
end
