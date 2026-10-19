# frozen_string_literal: true

module Shared
  # The shared type registry used by {ApplicationContract}.
  TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
    tc.add! :filter_scope, ::Filtering::Types::Filters

    tc.add! :identifier, ::Support::GlobalTypes::Slug

    tc.add! :solution_kind, Solutions::Types::Kind

    tc.add_model! "Provider"
    tc.add_model! "Solution"
    tc.add_model! "SolutionDraft"
    tc.add_model! "SolutionIntake"

    # A concern rather than a model, so it cannot use `add_model!`.
    tc.add! :controlled_vocabulary_record, ::Support::Types::Instance(::ControlledVocabularyRecord)
    tc.add! :controlled_vocabulary_records, ::Support::Types::Array.of(::Support::Types::Instance(::ControlledVocabularyRecord))
  end
end
