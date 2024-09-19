# frozen_string_literal: true

module ControlledVocabularies
  class TermFinder < Support::HookBased::Actor
    include ControlledVocabularies::CachesTerm
    include Dry::Core::Memoizable
    include Dry::Initializer[undefined: false].define -> do
      param :vocab, Types.Instance(::ControlledVocabulary)

      param :term, Types::Coercible::String
    end

    standard_execution!

    delegate :strategy, to: :vocab

    # @return [Object, nil]
    attr_reader :result

    def call
      run_callbacks :execute do
        yield prepare!

        yield find_by_strategy!
      end

      Success result
    end

    wrapped_hook! def prepare
      @result = nil

      super
    end

    wrapped_hook! def find_by_strategy
      return Failure[:empty_term] if term.blank?

      case strategy
      in "countries"
        yield find_countries_term!
      in "currencies"
        yield find_currencies_term!
      in "enum"
        yield find_enum_term!
      in "model"
        yield find_model_term!
      else
        # :nocov:
        return Failure[:unknown_strategy, strategy]
        # :nocov:
      end

      super
    end

    wrapped_hook! def find_countries_term
      country = maybe_find_country

      return Failure[:unknown_term, vocab.name, term] unless country.present?

      @result = country.alpha2

      super
    end

    wrapped_hook! def find_currencies_term
      currency = Money::Currency.find(term)

      return Failure[:unknown_term, vocab.name, term] unless currency.present?

      @result = currency.iso_code

      super
    end

    wrapped_hook! def find_enum_term
      @result = vocab.enum_lookup_map.fetch(term)
    rescue KeyError
      Failure[:unknown_term, vocab.name, term]
    else
      super
    end

    wrapped_hook! def find_model_term
      @result = cache_term_result(term, vocab:) do
        vocab.model_klass.where(term:).first!
      end
    rescue ActiveRecord::RecordNotFound
      Failure[:unknown_term, vocab.name, term]
    else
      super
    end

    private

    def maybe_find_country
      case term
      when /\A[[:alpha:]]{2}\z/
        ISO3166::Country.find_country_by_alpha2(term)
      else
        ISO3166::Country.find_country_by_any_name(term)
      end
    end
  end
end
