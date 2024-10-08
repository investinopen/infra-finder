# frozen_string_literal: true

# A concern for models that act as options to certain properties on a {Solution}.
module ControlledVocabularyRecord
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  include BuildsSelectOptions
  include ExposesRansackable
  include Filterable
  include HasName
  include HasVisibility
  include TimestampScopes

  HAS_SOLUTION_KIND = ControlledVocabularies::Types.Interface(:solution_kind)

  included do
    extend Dry::Core::ClassAttributes
    extend FriendlyId

    pg_enum! :provides, as: :controlled_vocabulary_provision, allow_blank: true, default: nil, prefix: :provides

    defines :auto_hidden_provisions, type: ControlledVocabularies::Types::Provisions
    defines :vocab_name, type: ControlledVocabularies::Types::VocabName
    defines :actual_linkage, type: ControlledVocabularies::Linkage
    defines :draft_linkage, type: ControlledVocabularies::Linkage

    auto_hidden_provisions [].freeze

    scope :in_bespoke_filter_order, -> { where.not(bespoke_filter_position: nil).reorder(bespoke_filter_position: :asc, term: :asc) }
    scope :in_default_order, -> { in_provision_order.lazily_order(:name) }
    scope :in_filter_order, -> { in_provision_order.lazily_order(:name) }

    scope :used, -> { where.not(id: unscoped.unused.select(:id)) }
    scope :unused, -> { where.missing(:solutions, :solution_drafts) }

    scope :with_providing, ->(provides) { where(provides:) }
    scope :sans_providing, ->(provides) { where(arel_table[:provides].eq(nil).or(arel_table[:provides].not_eq(provides))) }

    scope :actual, -> { sans_providing(:other) }
    scope :other, -> { with_providing(:other) }

    filter_collection_order_scope :in_filter_order

    friendly_id :slug_candidates, use: %i[history slugged]

    expose_ransackable_attributes! :description, on: :admin
    expose_ransackable_attributes! :term

    validates :term, controlled_vocabulary_term: true, presence: true, uniqueness: true

    delegate :actual_link_association, :actual_link_association_name,
      :draft_link_association, :draft_link_association_name,
      :actual_linkage, :draft_linkage, :linkage_for, to: :class

    before_validation :derive_counters!
    before_validation :maybe_auto_hide!
  end

  def has_auto_hidden_provision?
    provides? && provides.in?(self.class.auto_hidden_provisions)
  end

  def slug_candidates
    enforced_slug.presence || name
  end

  # @return [ActiveRecord::Relation<ControlledVocabularyLink>]
  def actual_links
    __send__(actual_link_association_name)
  end

  # @return [ActiveRecord::Relation<ControlledVocabularyLink>]
  def draft_links
    __send__(draft_link_association_name)
  end

  # @param [:actual, :draft] kind
  # @return [ActiveRecord::Reflection::HasManyReflection]
  def link_association_for(kind)
    case kind
    in :actual
      actual_link_association
    in :draft
      draft_link_association
    else
      # :nocov:
      raise "invalid solution kind: #{kind}"
      # :nocov:
    end
  end

  # @param [ControlledVocabularyRecord] new_option
  monadic_matcher! def replace_with(new_option)
    call_operation("controlled_vocabularies.replace", self, new_option)
  end

  # @api private
  # @return [void]
  def derive_counters!
    self.solutions_count = solutions.count
    self.solution_drafts_count = solution_drafts.mutable.count
  end

  # @return [void]
  def refresh_counters!
    derive_counters!

    update_columns(solutions_count:, solution_drafts_count:) if solutions_count_changed? || solution_drafts_count_changed?
  end

  # @!group Test / Debug Helpers

  # @param [<SolutionInterface>] records
  # @param [String] assoc
  # @return [Hash]
  def connect_multiple!(*records, assoc:)
    records.uniq.group_by(&:solution_kind).reverse_merge(actual: [], draft: []) => { actual:, draft:, }

    res = {}

    res[:actual] = connect_multiple_through!(*actual, assoc:, linkage: actual_linkage)
    res[:draft] = connect_multiple_through!(*draft, assoc:, linkage: draft_linkage)

    return res
  end

  # @param [SolutionInterface] record
  # @return [ActiveRecord::Result]
  def connect_single!(record, assoc:)
    linkage = linkage_for(record)

    tuples = [
      {
        assoc:,
        single: true,
        linkage.source_id => record.id,
        linkage.target_id => id,
      }
    ]

    unique_by = linkage.indices.name_for(:single)

    linkage.link_model.upsert_all(tuples, unique_by:)
  end

  # @!endgroup

  private

  # @param [<SolutionInterface>] records
  # @param [String] assoc
  # @return [ActiveRecord::Result, nil]
  def connect_multiple_through!(*records, assoc:, linkage:)
    return if records.blank?

    tuples = records.map do |record|
      {
        assoc:,
        single: false,
        linkage.source_id => record.id,
        linkage.target_id => id,
      }
    end

    unique_by = linkage.indices.name_for(:multiple)

    linkage.link_model.upsert_all(tuples, unique_by:)
  end

  # @return [void]
  def maybe_auto_hide!
    self.visibility = :hidden if has_auto_hidden_provision?
  end

  module ClassMethods
    delegate :name, to: :actual_link_association, prefix: true
    delegate :name, to: :draft_link_association, prefix: true

    # @param [ControlledVocabularies::Types::VocabName] name
    # @return [void]
    def uses_vocab!(name)
      vocab_name name

      derive_linkages!
      derive_associations!
    end

    def actual_link_association
      @actual_link_association ||= reflect_on_association(:solutions).through_reflection
    end

    def draft_link_association
      @draft_link_association ||= reflect_on_association(:solution_drafts).through_reflection
    end

    # @param [<#to_s>] raw_provisions
    # @return [void]
    def auto_hide_provisions!(*raw_provisions)
      provisions = ControlledVocabularies::Types::Provisions[raw_provisions.flatten]

      current = auto_hidden_provisions

      auto_hidden_provisions (current | provisions).freeze
    end

    # @param [SolutionInterface, :actual, :draft]
    # @return [ControlledVocabularies::Linkage]
    def linkage_for(record_or_kind)
      case record_or_kind
      in :actual
        actual_linkage
      in :draft
        draft_linkage
      in HAS_SOLUTION_KIND
        linkage_for(record_or_kind.solution_kind)
      end
    end

    def order_for_select_options
      in_filter_order
    end

    def policy_class
      ControlledVocabularyRecordPolicy
    end

    # @return [void]
    def refresh_counters!
      find_each(&:refresh_counters!)
    end

    def select_option_props_expression
      arel_named_fn(
        "jsonb_build_object",
        "data-vocab-name", arel_quote(vocab_name),
        "data-provides", arel_table[:provides]
      )
    end

    # @return [ActiveRecord::Relation<ControlledVocabularyRecord>]
    def in_provision_order
      expr = arel_case do |stmt|
        stmt.when(arel_is_other).then(100)
        stmt.else(0)
      end.asc

      order(expr)
    end

    # @api private
    def arel_is_other
      arel_table[:provides].eq("other")
    end

    private

    # @return [void]
    def derive_linkages!
      ControlledVocabularies::Linkage.for_record(vocab_name) => {
        actual_linkage:,
        draft_linkage:,
      }

      actual_linkage actual_linkage
      draft_linkage draft_linkage
    end

    # @return [void]
    def derive_associations!
      derive_associations_for! actual_linkage
      derive_associations_for! draft_linkage
    end

    # @param [ControlledVocabularies::Linkage] linkage
    # @return [void]
    def derive_associations_for!(linkage)
      has_many linkage.link_table_name, inverse_of: linkage.target_reference, dependent: :destroy
      has_many linkage.source, through: linkage.link_table_name
    end
  end
end
