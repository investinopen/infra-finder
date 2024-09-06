# frozen_string_literal: true

# @see SolutionProperty
class SolutionPropertyKind < Support::FrozenRecordHelpers::AbstractRecord
  include ActiveModel::Validations
  include Dry::Core::Memoizable

  Matcher = SolutionProperties::Types.Instance(self).constructor do |value|
    case value
    when ::SolutionPropertyKind then value
    when ::SolutionProperties::Types::Kind
      ::SolutionPropertyKind.find(value.to_sym)
    else
      # :nocov:
      raise Dry::Types::CoercionError, "invalid solution property kind: #{value}"
      # :nocov:
    end
  end

  schema!(types: SolutionProperties::TypeRegistry) do
    required(:kind).value(:kind)
    required(:assign_method).value(:assign_method)
    required(:diffable).value(:bool)
    required(:standard).value(:bool)
    optional(:input_kind).maybe(:symbol)
    optional(:input_html).maybe(:hash)
    optional(:input_options).maybe(:hash)
    optional(:connection_mode).maybe(:connection_mode)
    required(:diff_klass_name).value(:string)
  end

  default_attributes!(
    assign_method: :write_attribute,
    diffable: false,
    diff_klass_name: "UnknownDiff",
    input_kind: nil,
    input_html: {},
    input_options: {},
    standard: true
  )

  self.primary_key = :kind

  add_index :kind, unique: true
  add_index :assign_method
  add_index :standard

  scope :diffable, -> { where(diffable: true) }

  scope :standard, -> { where(standard: true) }

  scope :non_standard, -> { where(standard: false) }

  # @return [Class(SolutionProperties::Accessors::AbstractAccessor)]
  memoize def accessor_klass
    "solution_properties/accessors/#{kind}".classify.constantize
  end

  # @param [SolutionProperty] property
  # @return [Symbol, nil]
  def input_kind_for(property)
    return input_kind if input_kind?

    case kind
    when :multi_option
      multi_option_input_kind_for(property)
    when :single_option
      single_option_input_kind_for(property)
    end
  end

  def input_html
    super.try(:symbolize_keys)
  end

  def input_options
    super.try(:symbolize_keys)
  end

  memoize def diff_klass
    "::Solutions::Revisions::Diffs::#{diff_klass_name}".constantize
  end

  private

  # @param [SolutionProperty] _property
  # @return [Symbol, nil]
  def multi_option_input_kind_for(_property)
    :check_boxes
  end

  # @param [SolutionProperty] _property
  # @return [Symbol, nil]
  def single_option_input_kind_for(_property)
    :select
  end

  class << self
    # @return [<Symbol>]
    def non_standard_kinds
      non_standard.pluck(:kind)
    end

    # @return [<Symbol>]
    def standard_kinds
      standard.pluck(:kind)
    end
  end
end
