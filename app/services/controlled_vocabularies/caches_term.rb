# frozen_string_literal: true

module ControlledVocabularies
  module CachesTerm
    extend ActiveSupport::Concern

    def cache_term_result(term, vocab:, force: Rails.env.test?, &)
      Rails.cache.fetch(term_cache_key_for(term, vocab:), expires_in: 15.minutes, force:, &)
    end

    def term_cache_key_for(term, vocab:)
      "controlled_vocabularies/#{vocab.name}/#{term}/result"
    end
  end
end
