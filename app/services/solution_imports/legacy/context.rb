# frozen_string_literal: true

module SolutionImports
  module Legacy
    class Context < SolutionImports::AbstractContext
      strategy "legacy"

      option :rows, Types.Instance(CSV::Table)
    end
  end
end
