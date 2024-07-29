# frozen_string_literal: true

module SolutionProperties
  class ParseDateRange
    include Dry::Monads[:result, :maybe, :do]

    DATE_RANGE_PATTERN = /
      (?<started_on_month>\d{2}).(?<started_on_year>\d{4})
      .+?
      (?<ended_on_month>\d{2}).(?<ended_on_year>\d{4})
    /x

    EMPTY_BOUNDS = {
      started_on: nil,
      ended_on: nil,
    }.freeze

    # @param [String] input
    # @param [#to_s] prefix
    # @return [Dry::Monads::Success(Hash)]
    # @return [Dry::Monads::Failure(:invalid_date, String)]
    def call(input, prefix: nil)
      bounds = parse(input).value_or(EMPTY_BOUNDS.dup)

      bounds.transform_keys! { :"#{prefix}_#{_1}" } if prefix

      Success(bounds)
    end

    private

    def parse(input)
      case input
      when DATE_RANGE_PATTERN
        started_on = yield parse_month(Regexp.last_match[:started_on_year], Regexp.last_match[:started_on_month])

        ended_on = yield parse_month(Regexp.last_match[:ended_on_year], Regexp.last_match[:ended_on_month])

        Success({ started_on:, ended_on:, })
      else
        None()
      end
    end

    # @param [String] year
    # @param [String] month
    # @return [Dry::Monads::Maybe(Date)]
    # @return [Dry::Monads::Failure(:invalid_date, String)]
    def parse_month(year, month)
      raw = "#{year}-#{month}-01"

      Maybe(Date.parse(raw))
    rescue Date::Error
      Failure[:invalid_date, raw]
    end
  end
end
