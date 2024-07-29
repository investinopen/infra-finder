# frozen_string_literal: true

module ControlledVocabularies
  class UpsertAllRecords
    include Dry::Monads[:result, :do]

    def call
      ControlledVocabulary.uses_model.each do |vocab|
        yield vocab.upsert_records
      end

      Success()
    end
  end
end
