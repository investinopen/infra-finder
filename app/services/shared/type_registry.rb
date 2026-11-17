# frozen_string_literal: true

module Shared
  # The shared type registry used by {ApplicationContract}.
  TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
    tc.add! :controlled_vocabulary_record, ::ControlledVocabularyRecord::Type
    tc.add! :controlled_vocabulary_records, ::ControlledVocabularyRecord::List

    tc.add! :filter_scope, ::Filtering::Types::Filters

    tc.add! :identifier, ::Support::GlobalTypes::Slug

    tc.add! :solution_kind, Solutions::Types::Kind

    tc.add_model! "Comment"
    tc.add_model! "Invitation"
    tc.add_model! "Provider"
    tc.add_model! "ProviderEditorAssignment"
    tc.add_model! "Solution"
    tc.add_model! "SolutionDraft"
    tc.add_model! "SolutionIntake"
  end
end
