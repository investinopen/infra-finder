# frozen_string_literal: true

module SolutionImports
  module Legacy
    class ParseGrants
      include Dry::Monads[:result, :maybe, :do]

      EMPTY = <<~TEXT.strip
      Award title -
      Date (start, end dates) -
      Funder -
      Amount -
      Grant activities - (research and development, operations, strategy/governance/business planning, other)
      Link to award or award announcement, if available -
      TEXT

      PATTERNED = /\A
      Award\s+title\s+-\s+(?<name>.*?)\n
      (?:Date\s+\(start,\s+end\s+dates\)\s+-\s+(?<display_date>.*?)\n)?
      (?:Funder\s+-\s*(?<funder>.*?)\n)?
      (?:Amount\s+-\s*(?<amount>.*?)\n)?
      (?:Grant\s+activities\s+-\s*(?<grant_activities>.*?)\n)?
      (?:Link[^-]+?-\s*(?<award_announcement_url>[^\n]*)\n*)?
      /mix

      EMPTY_PATTERNS = [
        "(research and development, operations, strategy/governance/business planning, other)",
        "N/A",
      ].freeze

      # @param [String, nil] input
      # @return [Dry::Monads::Success<Hash>]
      def call(input)
        return Success([]) if input.blank? || empty?(input)

        case input
        when PATTERNED
          grant = Regexp.last_match.named_captures.symbolize_keys.transform_values do |value|
            value unless value.in?(EMPTY_PATTERNS)
          end

          award_announcement_url = grant.delete(:award_announcement_url)

          case award_announcement_url
          when Types::URL
            grant[:award_announcement_url] = award_announcement_url
          else
            grant[:notes] = award_announcement_url
          end

          Success([grant])
        else
          Success([{ notes: input }])
        end
      end

      private

      def empty?(input)
        input.match?(/none/i) || input.lines.map(&:strip).join("\n") == EMPTY
      end
    end
  end
end
