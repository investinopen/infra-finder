# frozen_string_literal: true

module SolutionProperties
  class ParseVocabName
    include Dry::Monads[:maybe]

    def call(value)
      case value
      when /\Acurrencies\z/i, "https://en.wikipedia.org/wiki/List_of_circulating_currencies"
        Some("currencies")
      when /\Acountries\z/i, "https://www.wikidata.org/wiki/Wikidata:WikiProject_Countries"
        Some("countries")
      when /\ASaaS\z/i
        Some("saas")
      else
        Maybe(value.presence&.underscore)
      end
    end
  end
end
