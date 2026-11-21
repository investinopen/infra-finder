# frozen_string_literal: true

module ControlledVocabularies
  # @see ControlledVocabularies::SyncEntries
  class EntriesSynchronizer < Support::HookBased::Actor
    standard_execution!

    # @return [<String>]
    attr_reader :names

    # @return [Dry::Monads::Success(Integer)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield prune!

        yield sync!
      end

      Success names.size
    end

    wrapped_hook! def prepare
      @names = ControlledVocabulary.pluck(:name)

      super
    end

    wrapped_hook! def prune
      ControlledVocabularyEntry.where.not(name: names).delete_all

      super
    end

    wrapped_hook! def sync
      ControlledVocabulary.find_each do |vocabulary|
        yield vocabulary.synchronize
      end

      super
    end
  end
end
