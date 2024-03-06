# frozen_string_literal: true

module SolutionImports
  module Legacy
    class ParseFinancialNumbersApplicability < EnumParser
      enum_type SolutionImports::Types::FinancialNumbersApplicability

      def parse(input)
        case input
        in 1 then "not_applicable"
        in 2 then "applicable"
        else
          "unknown"
        end
      end
    end
  end
end
