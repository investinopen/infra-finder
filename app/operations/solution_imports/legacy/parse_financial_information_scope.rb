# frozen_string_literal: true

module SolutionImports
  module Legacy
    class ParseFinancialInformationScope < EnumParser
      enum_type SolutionImports::Types::FinancialInformationScope

      def parse(input)
        case input
        in 1 then "host"
        in 2 then "not_applicable"
        in 3 then "project"
        else
          "unknown"
        end
      end
    end
  end
end
