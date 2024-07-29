# frozen_string_literal: true

module ControlledVocabularies
  class RecordUpserter < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :vocab, Types.Instance(::ControlledVocabulary)
    end

    include MonadicPersistence

    standard_execution!

    # @return [Class]
    attr_reader :model_klass

    # @return [Integer]
    attr_reader :record_count

    def call
      run_callbacks :execute do
        yield prepare!

        yield upsert!
      end

      Success record_count
    end

    wrapped_hook! def prepare
      @record_count = 0

      # :nocov:
      return Failure[:must_be_model, vocab.name] unless vocab.uses_model?
      # :nocov:

      @model_klass = vocab.model_klass

      super
    end

    wrapped_hook! def upsert
      vocab.terms.each do |term|
        yield upsert_single! term

        @record_count += 1
      end

      super
    end

    private

    # @param [ControlledVocabularies::TermDefinition] term_definition
    # @return [Dry::Monads::Result]
    def upsert_single!(term_definition)
      term_definition => { term:, }

      instance = model_klass.where(term:).first_or_create do |record|
        record.name = term
      end

      instance.assign_attributes(**term_definition.to_assign)

      monadic_save instance
    end
  end
end
