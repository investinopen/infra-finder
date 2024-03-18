# frozen_string_literal: true

# An abstract interface shared between {Solution} & {SolutionDraft}.
module SolutionInterface
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  include ExposesRansackable
  include HasName
  include HasSystemTags
  include SolutionImportable
  include StoreModelIntrospection

  ATTACHMENTS = %i[
    logo
  ].freeze

  BLURBS = %i[
    content_licensing
    funding_needs
    governance_summary
    key_achievements
    mission
    organizational_history
    service_summary
    special_certifications_or_statuses
    standards_employed
    what_registered
    what_other_tools
    what_technologies
  ].freeze

  CORE = %i[
    name
    founded_on
    location_of_incorporation
    member_count
    current_staffing
  ].freeze

  CONTACT = %i[
    contact
    website
    research_organization_registry_url
  ].freeze

  FINANCES = %i[
    annual_expenses
    annual_revenue
    investment_income
    other_revenue
    program_revenue
    total_assets
    total_contributions
    total_liabilities

    financial_numbers_applicability
    financial_numbers_publishability
    financial_information_scope
    financial_numbers_documented_url
  ].freeze

  IMPLEMENTATIONS = %i[
    bylaws
    code_license
    code_of_conduct
    code_repository
    community_engagement
    equity_and_inclusion
    governance_activities
    governance_structure
    open_api
    open_data
    pricing
    privacy_policy
    product_roadmap
    user_contribution_pathways
    user_documentation
    web_accessibility
  ].freeze

  IMPLEMENTATIONS_WITH_ENUMS = IMPLEMENTATIONS.flat_map do |implementation|
    [implementation, :"#{implementation}_implementation"]
  end

  SINGLE_OPTIONS = %i[
    board_structure
    business_form
    community_governance
    hosting_strategy
    maintenance_status
    primary_funding_source
    readiness_level
  ].freeze

  MULTIPLE_OPTIONS = %i[
    licenses
    solution_categories
    user_contributions
  ].freeze

  TAG_ASSOCIATIONS = %i[
    key_technologies
  ].freeze

  TAG_MAPPING = TAG_ASSOCIATIONS.index_with do |assoc|
    :"#{assoc.to_s.singularize}_list"
  end.with_indifferent_access.freeze

  TAG_LOOKUP = TAG_MAPPING.invert.with_indifferent_access.transform_values(&:to_sym).freeze

  TAG_LISTS = TAG_LOOKUP.keys.map(&:to_sym).freeze

  # @!group Composite Attributes

  STORE_MODEL_LISTS = %i[
    comparable_products
    current_affiliations
    founding_institutions
    recent_grants
    service_providers
    top_granting_institutions
  ].freeze

  STANDARD_ATTRIBUTES = [
    *CORE,
    *CONTACT,
    *BLURBS,
    *FINANCES,
  ].freeze

  TO_CLONE = [
    *ATTACHMENTS,
    *STANDARD_ATTRIBUTES,
    *IMPLEMENTATIONS_WITH_ENUMS,
    *SINGLE_OPTIONS,
    *MULTIPLE_OPTIONS,
    *STORE_MODEL_LISTS,
    *TAG_LISTS,
  ].freeze

  TO_EAGER_LOAD = [
    :organization,
    *MULTIPLE_OPTIONS,
    *SINGLE_OPTIONS,
    TAG_ASSOCIATIONS.index_with(:taggings),
  ].freeze

  TO_RANSACKABLE_ASSOCS = [
    "organization",
    *SINGLE_OPTIONS,
    *MULTIPLE_OPTIONS,
    *TAG_ASSOCIATIONS,
  ].freeze

  TO_RANSACKABLE_ATTRS = [
    *STANDARD_ATTRIBUTES,
    *IMPLEMENTATIONS_WITH_ENUMS,
    *STORE_MODEL_LISTS,
    *TAG_LISTS,
    *SINGLE_OPTIONS.map { "#{_1}_id" }
  ].freeze

  # @!endgroup

  included do
    extend Dry::Core::ClassAttributes

    include ImageUploader::Attachment.new(:logo)

    defines :solution_kind, type: Solutions::Types::Kind

    case name
    in "Solution"
      solution_kind :actual
    in "SolutionDraft"
      solution_kind :draft
    end

    TAG_ASSOCIATIONS.each do |assoc|
      acts_as_ordered_taggable_on assoc
    end

    attribute :comparable_products, Solutions::ComparableProduct.to_array_type, default: proc { [] }
    attribute :current_affiliations, Solutions::Institution.to_array_type, default: proc { [] }
    attribute :founding_institutions, Solutions::Institution.to_array_type, default: proc { [] }
    attribute :recent_grants, Solutions::Grant.to_array_type, default: proc { [] }
    attribute :service_providers, Solutions::ServiceProvider.to_array_type, default: proc { [] }
    attribute :top_granting_institutions, Solutions::Institution.to_array_type, default: proc { [] }

    scope :with_all_facets_loaded, -> { preload(*TO_EAGER_LOAD).strict_loading }

    before_validation :derive_contact_method!
    before_validation :set_default_identifier!

    validates *STORE_MODEL_LISTS, store_model: true

    validates :website, :research_organization_registry_url, url: { allow_blank: true }

    delegate :applies?, :applies_to_project?, :applies_to_website?,
      to: :web_accessibility, prefix: :web_accessibility_statement

    expose_ransackable_associations!(*TO_RANSACKABLE_ASSOCS)
    expose_ransackable_attributes!(*TO_RANSACKABLE_ATTRS)
    expose_ransackable_scopes!(*each_implementation.flat_map(&:ransackable_scopes))
  end

  # @api private
  # @return [String]
  def derive_contact_method
    case contact
    when /\Amailto:\S+\z/
      "email"
    when Support::GlobalTypes::URL_PATTERN
      "website"
    else
      "unavailable"
    end
  end

  # @api private
  # @return [void]
  def derive_contact_method!
    self.contact_method = derive_contact_method
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

  # @return [Solutions::Types::Kind]
  def solution_kind
    self.class.solution_kind
  end

  module ClassMethods
    # @see Solutions::StrongParamsBuilder
    # @param [{ Symbol => Object }] options
    # @option options [User, nil] current_user
    # @option options [Boolean] draft
    # @return [Array]
    def build_strong_params(...)
      InfraFinder::Container["solutions.build_strong_params"].(...).value_or([])
    end

    def draft?
      name == "SolutionDraft"
    end

    # @return [void]
    def define_common_attributes!
      # :nocov:
      return unless table_exists?
      # :nocov:

      define_common_associations!

      define_common_implementations!

      define_contact_method!

      define_financial_enums!
    rescue ActiveRecord::NoDatabaseError
      # :nocov:
      # intentionally left blank
      # :nocov:
    end

    # @api private
    # @return [void]
    def define_common_associations!
      inverse_of = model_name.plural.to_sym

      SINGLE_OPTIONS.each do |assoc|
        belongs_to assoc, inverse_of:, optional: true
      end

      inverse_of = model_name.singular.to_sym

      MULTIPLE_OPTIONS.each do |assoc|
        join_assoc = link_association_for(assoc)

        has_many join_assoc, -> { in_default_order }, inverse_of:, dependent: :destroy

        has_many assoc, through: join_assoc
      end
    end

    # @api private
    # @return [void]
    def define_common_implementations!
      each_implementation do |impl|
        define_implementation_for!(impl)
      end
    end

    def define_contact_method!
      pg_enum! :contact_method, as: :contact_method, prefix: :contact_via, allow_blank: false, default: :unavailable

      alias_method :contact_unavailable?, :contact_via_unavailable?

      scope :contact_unavailable, -> { contact_via_unavailable }
    end

    # @api private
    def define_financial_enums!
      pg_enum! :financial_information_scope, as: :financial_information_scope, prefix: :financial_information_scope, allow_blank: false, default: "unknown"
      pg_enum! :financial_numbers_applicability, as: :financial_numbers_applicability, prefix: :financial_numbers, default: "unknown"
      pg_enum! :financial_numbers_publishability, as: :financial_numbers_publishability, prefix: :financial_numbers, suffix: :to_publish, default: "unknown"

      validates :financial_information_scope, :financial_numbers_applicability, :financial_numbers_publishability, presence: true

      validates :financial_numbers_documented_url, url: { allow_blank: true }
    end

    # @api private
    # @param [Solutions::ImplementationDetail] implementation
    # @return [void]
    def define_implementation_for!(implementation)
      pg_enum! implementation.enum, as: :implementation_status, default: :unknown, prefix: implementation.name

      attribute implementation.name, implementation.type.to_type, default: proc { {} }

      validates implementation.name, store_model: true
    end

    def each_implementation
      # :nocov:
      return enum_for(__method__) unless block_given?
      # :nocov:

      implementations.each do |implementation_detail|
        yield implementation_detail
      end
    end

    # @see Solutions::DeriveFieldKind
    # @param [#to_sym] field
    # @return [Symbol, nil]
    def field_kind_for(field)
      InfraFinder::Container["solutions.derive_field_kind"].(field).value_or(nil)
    end

    # @return [<Solutions::ImplementationDetail>]
    def implementations
      @implementations ||= build_implementation_details
    end

    # @param [Symbol] options
    # @return [Symbol]
    def link_association_for(options)
      case options
      when /\Asolution_categories\z/
        draft? ? :solution_category_draft_links : :solution_category_links
      else
        inverse_of = model_name.singular.to_sym

        :"#{inverse_of}_#{options}"
      end
    end

    private

    def build_implementation_details
      IMPLEMENTATIONS.map do |name|
        type = "solutions/implementations/#{name}".camelize(:upper).constantize

        enum = :"#{name}_implementation"

        Solutions::ImplementationDetail.new(name:, type:, enum:)
      end
    end
  end
end
