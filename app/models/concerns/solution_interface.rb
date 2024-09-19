# frozen_string_literal: true

# An abstract interface shared between {Solution} & {SolutionDraft}.
#
# @see ControlledVocabulary
# @see Implementation
# @see SolutionProperty
module SolutionInterface
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  include BooleanEnums
  include ExposesRansackable
  include HasName
  include HasSystemTags
  include SolutionImportable
  include SolutionProperties::HasContact
  include SolutionProperties::HasControlledVocabularyConnections
  include SolutionProperties::HasCountryCode
  include SolutionProperties::HasFinance
  include SolutionProperties::HasFreeInputs
  include SolutionProperties::HasImplementations
  include SolutionProperties::HasLogo
  include SolutionProperties::HasStoreModelLists
  include SolutionProperties::HasSolutionKind
  include SolutionProperties::HasTextFields
  include StoreModelIntrospection

  included do
    extend Dry::Core::ClassAttributes

    has_normalized_name!

    scope :with_all_facets_loaded, -> { preload(:provider, *SolutionProperty.eager_load_associations).strict_loading }

    before_validation :set_default_identifier!

    after_commit :clear_editor_validation_application!

    validates :website, :research_organization_registry_url, url: { allow_blank: true }

    SolutionProperty.with_max_length.each do |prop|
      validates prop.attribute_name, length: { maximum: prop.max_length, if: :apply_editor_validations?, unless: :should_skip_editor_validations? }
    end

    SolutionProperty.with_presence_required.each do |prop|
      validates prop.attribute_name, presence: prop.required_presence_options
    end

    expose_ransackable_associations!(*SolutionProperty.ransackable_associations)
    expose_ransackable_attributes!(*SolutionProperty.ransackable_attributes)
    expose_ransackable_scopes!("provider", *Implementation.ransackable_scopes)
    expose_ransackable_scopes! :maintenance_active, :maintenance_inactive, :maintenance_unknown
  end

  # @see Solutions:ExtractAttributes
  monadic_operation! def extract_attributes
    call_operation("solutions.extract_attributes", self)
  end

  # @api private
  # @return [void]
  def set_default_identifier!
    self.identifier ||= SecureRandom.uuid
  end

  # @return [Boolean]
  attr_accessor :apply_editor_validations

  alias apply_editor_validations? apply_editor_validations

  # @api private
  # @return [void]
  def clear_editor_validation_application!
    @apply_editor_validations = false
  end

  # @return [Boolean]
  attr_accessor :skip_editor_validations

  # @see #skip_editor_validations
  # @see Solutions::Validations#should_skip_editor_validations?
  def should_skip_editor_validations?
    skip_editor_validations.present? || Solutions::Validations.should_skip_editor_validations?
  end

  module ClassMethods
    # @return [String]
    def export_public_csv
      InfraFinder::Container["admin.export_csv"].(SolutionInterface.private_csv_builder, all.with_all_facets_loaded).value!
    end

    # @return [String]
    def export_private_csv
      InfraFinder::Container["admin.export_csv"].(SolutionInterface.private_csv_builder, all.with_all_facets_loaded).value!
    end

    # @see Solutions::StrongParamsBuilder
    # @param [{ Symbol => Object }] options
    # @option options [User, nil] current_user
    # @option options [Boolean] draft
    # @return [Array]
    def build_strong_params(...)
      InfraFinder::Container["solutions.build_strong_params"].(...).value_or([])
    end

    # @see Solutions::DeriveFieldKind
    # @param [#to_sym] field
    # @return [Symbol, nil]
    def field_kind_for(field)
      InfraFinder::Container["solutions.derive_field_kind"].(field).value_or(nil)
    end
  end

  class << self
    # @return [void]
    def private_csv!(builder)
      build_scoped_csv_for(builder, scope: :private)
    end

    def public_csv!(builder)
      build_scoped_csv_for(builder, scope: :public)
    end

    # @return [ActiveAdmin::CSVBuilder]
    def private_csv_builder
      @private_csv_builder || build_private_csv_builder
    end

    # @return [ActiveAdmin::CSVBuilder]
    def public_csv_builder
      @public_csv_builder ||= build_public_csv_builder
    end

    private

    # @return [ActiveAdmin::CSVBuilder]
    def build_private_csv_builder
      ActiveAdmin::CSVBuilder.new force_quotes: true do
        SolutionInterface.private_csv!(self)
      end
    end

    # @return [ActiveAdmin::CSVBuilder]
    def build_public_csv_builder
      ActiveAdmin::CSVBuilder.new force_quotes: true do
        SolutionInterface.public_csv!(self)
      end
    end

    # @see Solutions::CSVColumnDefiner
    # @see Solutions::DefineCSVColumns
    # @param [ActiveAdmin::CSVBuilder] builder
    # @param [:private, :public] scope
    # @return [void]
    def build_scoped_csv_for(builder, scope:)
      InfraFinder::Container["solutions.define_csv_columns"].(builder, scope:).value!
    end
  end
end
