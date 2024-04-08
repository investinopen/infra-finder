# frozen_string_literal: true

# A concern for models that act as options to certain properties on a {Solution}.
module SolutionOption
  extend ActiveSupport::Concern

  include BuildsSelectOptions
  include ExposesRansackable
  include Filterable
  include SluggedByName
  include TimestampScopes

  included do
    extend Dry::Core::ClassAttributes

    defines :option_mode, type: Solutions::Types::OptionMode

    expose_ransackable_attributes! :description, on: :admin
  end

  module ClassMethods
    # @return [void]
    def multiple!
      include SolutionOption::Multiple
    end

    def policy_class
      SolutionOptionPolicy
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
    end

    module ClassMethods
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

      has_many :solutions, inverse_of: model_name.i18n_key, dependent: :restrict_with_error

      has_many :solution_drafts, inverse_of: model_name.i18n_key, dependent: :restrict_with_error
    end

    module ClassMethods
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
