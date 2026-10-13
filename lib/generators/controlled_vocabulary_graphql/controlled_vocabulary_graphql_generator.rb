# frozen_string_literal: true

# Generates the GraphQL object type for every model-backed {ControlledVocabulary}'s
# records, plus the `ControlledVocabularyKind` enum that identifies them.
#
# Run it after migrating, since it reads each model's columns.
#
# @see Types::ControlledVocabularyRecordType
class ControlledVocabularyGraphqlGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  # Columns exposed by {Types::ControlledVocabularyRecordType} or not exposed at all.
  SHARED_COLUMNS = %w[
    id seed_identifier name term slug enforced_slug description visibility provides
    bespoke_filter_position solutions_count solution_drafts_count solution_intakes_count
    created_at updated_at
  ].freeze

  # Column types that map to GraphQL scalars. Other column types are skipped.
  GRAPHQL_SCALARS = {
    boolean: "Boolean",
    integer: "Integer",
    string: "String",
    text: "String",
  }.freeze

  def generate_kind_enum!
    template "kind_enum.rb", Rails.root.join("app", "graphql", "types", "controlled_vocabulary_kind_type.rb"), force: true
  end

  def generate_types!
    vocabs.each do |vocab|
      @vocab = vocab

      template "type.rb", Rails.root.join("app", "graphql", "types", "#{vocab.model_klass.model_name.singular}_type.rb"), force: true
    end
  end

  private

  attr_reader :vocab

  # @return [<ControlledVocabulary>]
  def vocabs
    @vocabs ||= ControlledVocabulary.with_model_name.sort_by(&:model_name)
  end

  # @return [<(String, String)>] pairs of field name and GraphQL type
  def extra_fields
    vocab.model_klass.columns.filter_map do |column|
      next if column.name.in?(SHARED_COLUMNS)

      graphql_type = GRAPHQL_SCALARS[column.type]

      [column.name, graphql_type, column.null] if graphql_type
    end
  end

  # @param [ControlledVocabulary] vocab
  # @return [String]
  def enum_value_for(vocab)
    vocab.model_name.underscore.upcase
  end
end
