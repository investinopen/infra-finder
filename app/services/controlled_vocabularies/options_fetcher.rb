# frozen_string_literal: true

module ControlledVocabularies
  class OptionsFetcher < Support::HookBased::Actor
    extend Dry::Core::Cache

    include Dry::Initializer[undefined: false].define -> do
      param :vocab, Types.Instance(::ControlledVocabulary)
    end

    include MonadicPersistence

    standard_execution!

    delegate :name, to: :vocab, prefix: true

    # @return [<(String, String, Hash)>]
    attr_reader :options

    # @return [Class]
    attr_reader :model_klass

    # @return [Dry::Monads::Success<(String, String, Hash)>]
    def call
      run_callbacks :execute do
        yield prepare!

        yield fetch_options!
      end

      Success options
    end

    wrapped_hook! def prepare
      @options = []

      super
    end

    wrapped_hook! def fetch_options
      @options.concat yield options_for_strategy
    end

    wrapped_hook! def fetch_model_options
      @options.concat

      super
    end

    private

    def options_for_strategy
      case vocab.strategy
      in "countries"
        options_for_countries
      in "currencies"
        options_for_currencies
      in "enum"
        options_for_enum
      in "model"
        options_for_model
      else
        # :nocov:
        raise "invalid strategy: #{vocab.strategy}"
        # :nocov:
      end
    end

    def options_for_countries
      shared_props = { "data-vocab-name" => vocab_name }

      options = fetch_or_store(:countries, :options) do
        ISO3166::Country.pluck("iso_short_name", "alpha2").map do |(label, id)|
          [label, id, shared_props]
        end
      end

      Success options
    end

    def options_for_currencies
      shared_props = { "data-vocab-name" => vocab_name }

      options = fetch_or_store(:currencies, :options) do
        Money::Currency.all.map do |c|
          props = shared_props.merge(
            "data-iso-code" => c.iso_code
          )

          ["#{c.name} (#{c.iso_code})", c.iso_code, props]
        end
      end

      Success options
    end

    def options_for_enum
      options = fetch_or_store(vocab_name, :enum_options) do
        props = { "data-vocab-name" => vocab_name }

        vocab.mapping.map do |value, label|
          [label, value, props]
        end
      end

      Success options
    end

    def options_for_model
      Success vocab.model_klass.to_select_options
    end
  end
end
