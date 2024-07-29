# frozen_string_literal: true

module ControlledVocabularies
  class Replacer < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :old_option, Types::Record
      param :new_option, Types::Record

      option :replacement, Types.Instance(Replacement), default: proc { Replacement.new(old_option:, new_option:) }
    end

    prepend TransactionalCall

    standard_execution!

    # @return [{ ControlledVocabularies::Types::SourceKind => Integer }]
    attr_reader :updated

    # @return [ControlledVocabularies::Types::VocabName]
    attr_reader :vocab_name

    # @return [Dry::Monads::Success({ ControlledVocabularies::Types::SourceKind => Integer })]
    def call
      run_callbacks :execute do
        yield prepare!

        yield update_all_links!

        yield remove_old_option!
      end

      Success updated
    end

    wrapped_hook! def prepare
      return Failure[:invalid, replacement] unless replacement.valid?

      @vocab_name = old_option.class.vocab_name.to_s

      @updated = { actual: 0, draft: 0, }

      super
    end

    wrapped_hook! def update_all_links
      updated[:actual] += yield update_links_for! kind: :actual
      updated[:draft] += yield update_links_for! kind: :draft

      super
    end

    wrapped_hook! def remove_old_option
      old_option.destroy!

      new_option.refresh_counters!

      super
    end

    private

    # @param [:actual, :draft] kind
    # @return [Dry::Monads::Success]
    def update_links_for!(kind:)
      linkage = ControlledVocabularies::Linkage.for_link(vocab_name, kind)

      connections = load_tuples_for(linkage)

      upserted = connections.sum do |connection_mode, tuples|
        upsert_tuples!(connection_mode, tuples, linkage:)
      end

      Success upserted
    end

    # @param [ControlledVocabularies::Linkage] linkage
    def load_tuples_for(linkage)
      single, multiple = linkage.link_model.where(linkage.target_id => old_option.id).pluck(linkage.source_id, :assoc, :single).map do |source_id, assoc, single|
        {
          linkage.source_id => source_id,
          linkage.target_id => new_option.id,
          assoc:,
          single:,
        }
      end.partition do |tuple|
        tuple[:single]
      end

      { single:, multiple:, }
    end

    # @param [:single, :multiple] connection_mode
    # @param [<Hash>] tuples
    # @param [ControlledVocabularies::Linkage] linkage
    def upsert_tuples!(connection_mode, tuples, linkage:)
      return 0 if tuples.blank?

      unique_by = linkage.indices.name_for(connection_mode)

      result = linkage.link_model.upsert_all(tuples, unique_by:)

      result.length
    end
  end
end
