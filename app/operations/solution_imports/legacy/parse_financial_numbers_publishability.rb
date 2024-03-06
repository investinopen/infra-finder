# frozen_string_literal: true

module SolutionImports
  module Legacy
    class ParseFinancialNumbersPublishability < EnumParser
      enum_type SolutionImports::Types::FinancialNumbersPublishability

      def parse(input)
        case input
        in 1 then "not_applicable"
        in 2 then "unapproved"
        in 3 then "approved"
        else
          "unknown"
        end
      end
    end
  end
end
