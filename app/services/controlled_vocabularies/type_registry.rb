# frozen_string_literal: true

module ControlledVocabularies
  # The type registry used by {ControlledVocabulary}.
  TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
    tc.add! :assoc, ControlledVocabularies::Types::Assoc
    tc.add! :connection_mode, ControlledVocabularies::Types::ConnectionMode
    tc.add! :enum_mapping, ControlledVocabularies::Types::EnumMapping
    tc.add! :source_kind, ControlledVocabularies::Types::SourceKind
    tc.add! :source_table, ControlledVocabularies::Types::SourceTable
    tc.add! :strategy, ControlledVocabularies::Types::Strategy
    tc.add! :target_table, ControlledVocabularies::Types::TargetTable
    tc.add! :term, ControlledVocabularies::Types::Term
    tc.add! :term_definition, ControlledVocabularies::TermDefinition.schema
    tc.add! :term_definitions, ControlledVocabularies::Types::Array.of(ControlledVocabularies::TermDefinition)
    tc.add! :terms, ControlledVocabularies::Types::Terms
    tc.add! :visibility, ControlledVocabularies::Types::Visibility
    tc.add! :vocab_name, ControlledVocabularies::Types::VocabName
  end
end
