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

  included do
    extend Dry::Core::ClassAttributes

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

    has_normalized_name!

    scope :with_all_facets_loaded, -> { preload(:provider, *SolutionProperty.eager_load_associations).strict_loading }

    scope :complete, -> { where(missing_properties: []) }
    scope :incomplete, -> { where("cardinality(#{quoted_table_name}.missing_properties) > 0") }

    before_validation :set_default_identifier!

    before_save :derive_missing_properties!

    SolutionProperty.urls.each do |prop|
      validates prop.attribute_name, url: { allow_blank: true, no_local: true }
    end

    # Matches what browsers accept for `type="email"`, which the admin client uses.
    SolutionProperty.emails.each do |prop|
      validates prop.attribute_name, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }
    end

    SolutionProperty.with_max_length.each do |prop|
      validates prop.attribute_name, length: { maximum: prop.max_length, unless: :should_skip_editor_validations? }
    end

    validate :check_completeness!, on: :complete, unless: :should_skip_editor_validations?

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
    return if solution_kind == :intake

    self.identifier ||= SecureRandom.uuid
  end

  # @see Solutions::Validations#should_skip_editor_validations?
  def should_skip_editor_validations?
    Solutions::Validations.should_skip_editor_validations?
  end

  # @!group Completeness

  # Attributes that must have a value, beyond the required solution properties.
  #
  # @abstract
  # @return [<Symbol>]
  def additional_required_attributes = []

  # Whether every required property has a value, as of the last save.
  #
  # @return [Boolean, nil] nil when not yet checked
  def complete? = missing_properties&.empty?

  # @see Solutions::FindMissingProperties
  # @return [Dry::Monads::Success(<String>)]
  monadic_operation! def find_missing_properties
    call_operation("solutions.find_missing_properties", self)
  end

  # @api private
  # @return [void]
  def check_completeness!
    find_missing_properties!.each do |attribute|
      errors.add(attribute, :blank)
    end
  end

  # @api private
  # @return [void]
  def derive_missing_properties!
    self.missing_properties = find_missing_properties!
  end

  # @!endgroup

  module ClassMethods
    # @return [String]
    def export_public_csv
      InfraFinder::Container["admin.export_csv"].(SolutionInterface.private_csv_builder, all.with_all_facets_loaded).value!
    end

    # @return [String]
    def export_private_csv
      InfraFinder::Container["admin.export_csv"].(SolutionInterface.private_csv_builder, all.with_all_facets_loaded).value!
    end

    # @see SolutionProperties::BuildStrongParams
    # @see SolutionProperties::StrongParamsBuilder
    # @param [{ Symbol => Object }] options
    # @option options [User, nil] current_user
    # @return [Array]
    def build_strong_params(...)
      InfraFinder::Container["solution_properties.build_strong_params"].(solution_kind, ...).value_or([])
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
