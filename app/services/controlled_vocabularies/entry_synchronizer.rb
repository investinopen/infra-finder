# frozen_string_literal: true

module ControlledVocabularies
  # @see ControlledVocabularies::SyncEntry
  class EntrySynchronizer < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :vocabulary, Types::ControlledVocabulary
    end

    standard_execution!

    # @return [ControlledVocabularyEntry]
    attr_reader :entry

    # @return [Dry::Monads::Success(ControlledVocabularyEntry)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield sync!
      end

      Success entry
    end

    wrapped_hook! def prepare
      @entry = vocabulary.find_entry

      @attributes = vocabulary.to_entry_attributes

      super
    end

    wrapped_hook! def sync
      @entry.assign_attributes(@attributes)

      @entry.save!

      super
    end
  end
end
