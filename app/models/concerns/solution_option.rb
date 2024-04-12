# frozen_string_literal: true

# A concern for models that act as options to certain properties on a {Solution}.
module SolutionOption
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  include BuildsSelectOptions
  include ExposesRansackable
  include Filterable
  include SluggedByName
  include TimestampScopes

  included do
    extend Dry::Core::ClassAttributes

    defines :option_mode, type: Solutions::Types::OptionMode

    scope :used, -> { where.not(id: unscoped.unused.select(:id)) }
    scope :unused, -> { where.missing(:solutions, :solution_drafts) }

    expose_ransackable_attributes! :description, on: :admin

    before_validation :derive_counters!
  end

  def multiple_option?
    self.class.option_mode == :multiple
  end

  def single_option?
    self.class.option_mode == :single
  end

  # @param [SolutionOption] new_option
  monadic_matcher! def replace_with(new_option)
    call_operation("solutions.replace_option", self, new_option)
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

  module ClassMethods
    # @return [void]
    def multiple!
      include SolutionOption::Multiple
    end

    def policy_class
      SolutionOptionPolicy
    end

    def refresh_counters!
      find_each(&:refresh_counters!)
    end

    # @return [void]
    def single!
      include SolutionOption::Single
    end
  end

  # Options that a {Solution} can select multiple of, through a join record.
  module Multiple
    extend ActiveSupport::Concern

    included do
      option_mode :multiple

      defines :legacy_import_source_key, :legacy_import_lookup_key, type: SolutionImports::Types::Symbol

      legacy_import_lookup_key :"#{model_name.i18n_key}"
      legacy_import_source_key :"#{model_name.i18n_key}_names"

      delegate :actual_link_association, :actual_link_association_name,
        :draft_link_association, :draft_link_association_name, to: :class
    end

    # @return [ActiveRecord::Relation<SolutionOptionLink>]
    def actual_links
      __send__(actual_link_association_name)
    end

    # @return [ActiveRecord::Relation<SolutionOptionLink>]
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

    module ClassMethods
      delegate :name, to: :actual_link_association, prefix: true
      delegate :name, to: :draft_link_association, prefix: true

      def actual_link_association
        @actual_link_association ||= reflect_on_association(:solutions).through_reflection
      end

      def draft_link_association
        @draft_link_association ||= reflect_on_association(:solution_drafts).through_reflection
      end

      # @return [{ String => Integer }]
      def for_legacy_mapping
        seeded.lazily_order(:name).pluck(:name, :seed_identifier).to_h
      end
    end
  end

  # Options that a {Solution} can select only one of, as foreign keys directly on the record.
  module Single
    extend ActiveSupport::Concern

    included do
      option_mode :single

      defines :legacy_import_source_key, :legacy_import_target_key, type: SolutionImports::Types::Symbol

      legacy_import_source_key :"#{model_name.i18n_key}_id"
      legacy_import_target_key :"#{model_name.i18n_key}"

      has_many :solutions, inverse_of: model_name.i18n_key, dependent: :nullify

      has_many :solution_drafts, inverse_of: model_name.i18n_key, dependent: :nullify

      delegate :actual_association, :draft_association, to: :class
    end

    # @param [:actual, :draft] kind
    # @return [ActiveRecord::Reflection::HasManyReflection]
    def association_for(kind)
      case kind
      in :actual
        actual_association
      in :draft
        draft_association
      else
        # :nocov:
        raise "invalid solution kind: #{kind}"
        # :nocov:
      end
    end

    # @param [:actual, :draft] kind
    # @return [Symbol]
    def foreign_key_for(kind)
      association_for(kind).foreign_key
    end

    module ClassMethods
      def actual_association
        @actual_association ||= reflect_on_association(:solutions)
      end

      def draft_association
        @draft_association ||= reflect_on_association(:solution_drafts)
      end

      # @param [Hash] import_row
      # @return [Hash]
      def normalize_legacy_import!(import_row)
        seed_identifier = import_row.delete legacy_import_source_key

        normalized = by_seed_identifier(seed_identifier)

        import_row[legacy_import_target_key] = normalized if normalized.present?

        return import_row
      end
    end
  end
end
