# frozen_string_literal: true

# A logical grouping of links and statuses for various implementations of policies,
# features, etc that are tied to a {Solution}.
class Implementation < Support::FrozenRecordHelpers::AbstractRecord
  extend DefinesMonadicOperation

  include Dry::Core::Memoizable

  schema!(types: Implementations::TypeRegistry) do
    required(:name).filled(:implementation_name)
    required(:enum).filled(:string)
    required(:type_name).filled(:string)
    required(:enum_type).value(:enum_type)
    required(:code).value(:integer)
  end

  default_attributes!(enum_type: "implementation_status")

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
    phase_2_status: "none",
  }.freeze

  EXPOSED_SCOPE_SUFFIXES = %w[available].freeze

  PROPERTIES_PATH = Rails.root.join("lib", "properties", "implementations.yml")

  delegate :has_any_links?, :has_many_links?, :has_no_links?, :has_single_link?, :has_statement?, :link_mode, :linked?, :unlinked?, to: :type

  # @return [Dry::Types::Type]
  def data_dry_type
    Implementations::Types::Data
  end

  def each_property
    # :nocov:
    return enum_for(__method__) unless block_given?
    # :nocov:

    property_enumerator.each do |prop|
      yield prop
    end
  end

  # @return [Dry::Types::Type]
  def enum_dry_type
    case enum_type
    in "pricing_implementation_status"
      Implementations::Types::PricingStatus
    else
      Implementations::Types::Status
    end
  end

  # @return [SolutionProperty]
  memoize def enum_property
    SolutionProperty.find enum
  end

  def nested_attributes
    :"#{name}_attributes"
  end

  # @return [<String>]
  memoize def ransackable_scopes
    EXPOSED_SCOPE_SUFFIXES.map { "#{name}_#{_1}" }
  end

  memoize def structured_attr
    :"#{name}_structured"
  end

  memoize def structured_header
    :"#{name}_structured"
  end

  def title
    Solution.human_attribute_name(name)
  end

  # @return [Class]
  memoize def type
    type_name.constantize
  end

  # @return [ControlledVocabulary]
  memoize def vocab
    ControlledVocabulary.find vocab_name
  end

  def vocab_name
    case enum_type
    in "pricing_implementation_status"
      "impl_scale_pricing"
    else
      "impl_scale"
    end
  end

  def web_accessibility?
    /\Aweb_accessibility\z/.match?(name)
  end

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
