# frozen_string_literal: true

# A logical grouping of links and statuses for various implementations of policies,
# features, etc that are tied to a {Solution}.
class Implementation < Support::FrozenRecordHelpers::AbstractRecord
  extend DefinesMonadicOperation

  type_registry Implementations::TypeRegistry

  schema!(types: Implementations::TypeRegistry) do
    required(:name).filled(:implementation_name)
    required(:enum).filled(:string)
    required(:type_name).filled(:string)
    required(:enum_type).value(:enum_type)
    required(:code).value(:integer)

    required(:type).value(:class)

    required(:data_dry_type).value(:dry_type)
    required(:enum_dry_type).value(:dry_type)
    required(:ransackable_scopes).array(:string)
    required(:structured_attr).value(:symbol)
    required(:structured_header).value(:symbol)
    required(:title).filled(:string)
    required(:vocab_name).filled(:string)
    required(:vocab).value(ControlledVocabulary::Type)
    required(:web_accessibility).value(:bool)
  end

  default_attributes!(enum_type: "implementation_status")

  calculates! :data_dry_type do |record|
    Implementations::Types::Data
  end

  calculates! :enum_dry_type do |record|
    case record["enum_type"]
    in "pricing_implementation_status"
      Implementations::Types::PricingStatus
    else
      Implementations::Types::Status
    end
  end

  calculates! :type do |record|
    record["type_name"].constantize
  end

  calculates! :ransackable_scopes do |record|
    EXPOSED_SCOPE_SUFFIXES.map { "#{record["name"]}_#{_1}" }
  end

  calculates! :structured_attr do |record|
    :"#{record["name"]}_structured"
  end

  calculates! :structured_header do |record|
    :"#{record["name"]}_structured"
  end

  calculates! :title do |record|
    Solution.human_attribute_name(record["name"])
  end

  calculates! :vocab_name do |record|
    case record["enum_type"]
    in "pricing_implementation_status"
      "impl_scale_pricing"
    else
      "impl_scale"
    end
  end

  calculates! :vocab do |record|
    ControlledVocabulary.find(record["vocab_name"])
  end

  calculates! :web_accessibility do |record|
    /\Aweb_accessibility\z/.match?(record["name"])
  end

  self.primary_key = :name

  add_index :name, unique: true
  add_index :enum, unique: true
  add_index :code, unique: true

  scope :in_default_order, -> { order(code: :asc) }

  DEFAULT_SOLUTION_PROPERTY = {
    kind: :implementation,
    meta: true,
    exported: false,
    required: false,
    fe_position: 0,
    fe_visibility: "hidden",
  }.freeze

  EXPOSED_SCOPE_SUFFIXES = %w[available].freeze

  PROPERTIES_PATH = Rails.root.join("lib", "properties", "implementations.yml")

  delegate :has_any_links?, :has_many_links?, :has_no_links?, :has_single_link?, :has_statement?, :link_mode, :linked?, :unlinked?, to: :type

  def each_property
    # :nocov:
    return enum_for(__method__) unless block_given?
    # :nocov:

    property_enumerator.each do |prop|
      yield prop
    end
  end

  # @!attribute [r] enum_property
  # @return [SolutionProperty]
  def enum_property
    memoize :enum_property do
      SolutionProperty.find(enum)
    end
  end

  def nested_attributes = :"#{name}_attributes"

  def to_solution_property_definition
    DEFAULT_SOLUTION_PROPERTY.merge(
      name:,
      code:,
      attr: name,
      ext_name: "#{name}_ext",
      description: "Actual implementation property for #{title}",
      implementation_name: name,
      be_label: title,
    ).stringify_keys
  end

  private

  # @return [Enumerator<SolutionProperty>]
  def property_enumerator
    Enumerator.new do |yy|
      yy << enum_property

      SolutionProperty.implementation_properties_for(name).each do |prop|
        yy << prop
      end
    end
  end

  class << self
    def available_scope
      @available_scope ||= /\A(?<implementation>#{Regexp.union(*all.pluck(:name))})_available\z/
    end

    # @see #ransackable_scopes
    # @return [<String>]
    def ransackable_scopes
      all.flat_map(&:ransackable_scopes)
    end

    # @api private
    # @return [<Hash>]
    def property_definitions
      in_default_order.map(&:to_solution_property_definition)
    end

    # @api private
    # @return [void]
    def write_properties!
      PROPERTIES_PATH.open("wb+") do |f|
        f.write property_definitions.to_yaml
      end
    end
  end
end
