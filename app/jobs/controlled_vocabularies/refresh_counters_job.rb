# frozen_string_literal: true

module ControlledVocabularies
  class RefreshCountersJob < ApplicationJob
    include JobIteration::Iteration

    queue_as :maintenance

    # @param [String] cursor
    # @return [Enumerator]
    def build_enumerator(cursor:)
      options = ControlledVocabulary.model_klasses

      enumerator_builder.array(options, cursor:)
    end

    # @param [Class<ControlledVocabularyRecord>] klass
    def each_iteration(klass)
      klass.refresh_counters!
    end
  end
end
