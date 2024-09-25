# frozen_string_literal: true

module ControlledVocabularies
  class Linkage
    include Dry::Core::Memoizable
    include Dry::Initializer[undefined: false].define -> do
      option :vocab_name, Types::VocabName
      option :kind, Types::SourceKind

      option :vocab, Types.Instance(ControlledVocabulary), default: proc { ControlledVocabulary.uses_model.find(vocab_name) }
      option :source, Types::SourceTable, default: proc { kind }
      option :target, Types::TargetTable, default: proc { vocab.table_name }
    end

    delegate :foreign_key, :id, :model, :model_name, :reference, to: :source_table_ref, prefix: :source
    delegate :foreign_key, :id, :model, :model_name, :reference, to: :target_table_ref, prefix: :target

    memoize def indices
      Indices.new(linkage: self)
    end

    memoize def link_model
      link_model_name.safe_constantize
    end

    memoize def link_model_name
      link_table_name.to_s.classify
    end

    memoize def link_table_name
      if target == :solution_categories
        if source == :solution_drafts
          :solution_category_draft_links
        else
          :solution_category_links
        end
      else
        :"#{source_reference}_#{target}"
      end
    end

    memoize def source_table_ref
      TableReference.new(name: source)
    end

    memoize def target_table_ref
      TableReference.new(name: target)
    end

    # @api private
    # @return [Hash]
    def to_plurality_migration
      {
        indices: indices.to_plurality_migration,
        link_table_name: link_table_name.to_s,
        source: source_table_ref.to_plurality_migration,
        target: target_table_ref.to_plurality_migration,
      }
    end

    # @api private
    class Indices < Support::FlexibleStruct
      include Dry::Core::Memoizable

      attribute :linkage, Types.Instance(Linkage)

      delegate_missing_to :linkage

      def name_for(connection_mode)
        case connection_mode
        in :multiple then multiple_uniqueness_name
        in :single then single_uniqueness_name
        else
          # :nocov:
          raise "unknown mode: #{connection_mode}"
          # :nocov:
        end
      end

      memoize def multiple_uniqueness_columns
        [source_id, target_id, :assoc]
      end

      memoize def multiple_uniqueness_options
        {
          name: multiple_uniqueness_name,
          unique: true,
          where: %[NOT single],
        }
      end

      memoize def multiple_uniqueness_name
        :"udx_#{link_table_name}_multi"
      end

      memoize def single_uniqueness_columns
        [source_id, :assoc]
      end

      memoize def single_uniqueness_options
        {
          name: single_uniqueness_name,
          unique: true,
          where: %[single],
        }
      end

      memoize def single_uniqueness_name
        :"udx_#{link_table_name}_single"
      end

      def to_plurality_migration
        {
          multiple: name_for(:multiple),
          single: name_for(:single),
        }.transform_values(&:to_s)
      end
    end

    # @api private
    class TableReference < Support::FlexibleStruct
      include Dry::Core::Memoizable

      attribute :name, Support::Types::Coercible::Symbol

      memoize def foreign_key
        :"#{name.to_s.singularize}_id"
      end

      alias id foreign_key

      memoize def model
        model_name.safe_constantize
      end

      memoize def model_name
        name.to_s.classify
      end

      memoize def reference
        name.to_s.singularize.to_sym
      end

      memoize def table_name
        name.to_s
      end

      def to_plurality_migration
        {
          id: id.to_s,
          table_name:,
        }
      end
    end

    class << self
      # @param [ControlledVocabularies::Types::VocabName] name
      # @param [:actual, :draft] :kind
      # @return [ControlledVocabularies::Linkage]
      def for_link(vocab_name, kind)
        vocab = ControlledVocabulary.uses_model.find(vocab_name.to_s)

        new(vocab_name:, kind:, vocab:)
      end

      # @param [ControlledVocabularies::Types::VocabName] name
      # @return [{ Symbol => ControlledVocabularies::Linkage }]
      def for_record(vocab_name)
        actual_linkage = for_link(vocab_name, :actual)

        draft_linkage = for_link(vocab_name, :draft)

        { actual_linkage:, draft_linkage:, }
      end
    end
  end
end
