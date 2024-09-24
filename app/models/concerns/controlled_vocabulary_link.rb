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

    delegate :option_association,
      :solution_association,
      :solution_kind,
      :solution_link_association,
      :solution_link_association_name,
      :vocab_name,
      to: :class

    scope :for_assoc, ->(assoc) { where(assoc:) }

    scope :in_default_order, -> { joins(option_association.name).merge(option_association.klass.in_alphabetical_order) }
    scope :multiple, -> { where(single: false) }
    scope :single, -> { where(single: true) }
  end

  # @api private
  # @return [ActiveRecord::Relation<ControlledVocabularyLink>]
  def solution_connection_association
    __send__(solution_association.name).__send__(solution_link_association.name)
  end

  # @api private
  # @return [Integer]
  def multiple_selection_count_for(assoc)
    solution_connection_association.for_assoc(assoc).multiple.count
  end

  # @api private
  # @return [void]
  def check_connection_limits!
    ControlledVocabularyConnection.each_connection_with_length_limits_for(vocab_name:, solution_kind:) do |conn|
      if multiple_selection_count_for(conn.assoc) >= conn.max_length
        errors.add :base, :option_limit_exceeded
      end
    end
  end

  module ClassMethods
    delegate :name, to: :solution_link_association, prefix: true

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
      reflect_on_association(solution_association_name)
    end

    def solution_link_association
      solution_association.inverse_of
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

      before_validation :check_connection_limits!, unless: :single?
    end
  end
end
