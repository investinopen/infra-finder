# frozen_string_literal: true

# Connective tissue between a {ControlledVocabularyRecord} and either a {Solution} or a {SolutionDraft}.
module ControlledVocabularyLink
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  include ExposesRansackable
  include TimestampScopes

  included do
    extend Dry::Core::ClassAttributes

    defines :vocab_name, type: ControlledVocabularies::Types::VocabName
    defines :linkage, type: ControlledVocabularies::Linkage

    defines :option_association_name, type: ControlledVocabularies::Types::Symbol
    defines :solution_kind, type: Solutions::Types::Kind
    defines :solution_association_name, type: Solutions::Types::Symbol.enum(:solution, :solution_draft)

    scope :in_default_order, -> { joins(option_association.name).merge(option_association.klass.in_alphabetical_order) }
    scope :single, -> { where(single: true) }
  end

  module ClassMethods
    # @param [ControlledVocabularies::Types::VocabName] name
    # @param [:actual, :draft] :kind
    # @return [void]
    def links_vocab_with!(name, kind:)
      vocab_name name
      solution_kind kind

      derive_linkage!
      derive_associations!
      derive_validations!

      expose_ransackable_associations! option_association_name, solution_association_name, on: :admin
    end

    # @param [ControlledVocabularies::Types::VocabName] name
    # @return [void]
    def links_vocab_with_actual!(name)
      links_vocab_with!(name, kind: :actual)
    end

    # @param [ControlledVocabularies::Types::VocabName] name
    # @return [void]
    def links_vocab_with_draft!(name)
      links_vocab_with!(name, kind: :draft)
    end

    def option_association
      # :nocov:
      reflect_on_association(option_association_name)
      # :nocov:
    end

    def solution_association
      # :nocov:
      reflect_on_association(solution_association_name)
      # :nocov:
    end

    private

    # @return [void]
    def derive_linkage!
      linkage ControlledVocabularies::Linkage.for_link(vocab_name, solution_kind)

      solution_association_name linkage.source_reference
      option_association_name linkage.target_reference
    end

    # @return [void]
    def derive_associations!
      belongs_to linkage.source_reference, inverse_of: linkage.link_table_name
      belongs_to linkage.target_reference, inverse_of: linkage.link_table_name
    end

    def derive_validations!
      validates linkage.source_id, uniqueness: { scope: %i[assoc], if: :single? }
      validates linkage.source_id, uniqueness: { scope: [linkage.target_id, :assoc], unless: :single? }
    end
  end
end
