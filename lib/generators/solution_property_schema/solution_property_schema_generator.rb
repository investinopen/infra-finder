# frozen_string_literal: true

class SolutionPropertySchemaGenerator < Rails::Generators::NamedBase
  include Support::Generators::HasAttrMapping
  include Support::Generators::HasExistingKlass
  include Support::Generators::FormattedNaming
  include Support::Generators::Quoting
  include Support::Generators::WritesSchema

  source_root File.expand_path("templates", __dir__)

  fallback_type "Inputs::Types::Any"

  ENUM_SOURCE = "Inputs::Types::Enums"

  map_types!(
    attachment: "Inputs::Types::Any",
    blurb: "Inputs::Types::Attributes::String",
    boolean: "Inputs::Types::Attributes::Bool",
    contact: "Inputs::Types::Attributes::String",
    countries: "Inputs::Types::Enums::Countries",
    currencies: "Inputs::Types::Enums::Currencies",
    date: "Inputs::Types::Attributes::Date",
    email: "Inputs::Types::Attributes::String",
    financial_numbers_publishability: "Inputs::Types::Enums::FinancialNumbersPublishability",
    implementation_status: "Inputs::Types::Enums::ImplementationStatus",
    integer: "Inputs::Types::Attributes::Integer",
    money: "Inputs::Types::Attributes::Money",
    multi_option: "Inputs::Types::Attributes::IDs",
    other_option: "Inputs::Types::Attributes::String",
    pricing_implementation_status: "Inputs::Types::Enums::PricingImplementationStatus",
    publication: "Inputs::Types::Enums::Publication",
    single_option: "Inputs::Types::Attributes::ID",
    store_model_input: "Inputs::Types::Attributes::String",
    string: "Inputs::Types::Attributes::String",
    url: "Inputs::Types::Attributes::String"
  )

  def prepare!
    @solution_kind = klass.solution_kind
  end

  def collect_specific!
    if actual?
      add_to_schema! :provider_id, :single_option
      add_to_schema! :publication, :publication
    end

    if intake?
      add_to_schema! :launch_year, :integer
    end
  end

  # @return [void]
  def collect_standard!
    SolutionProperty.in_use.standard.each do |prop|
      case prop.kind
      in :enum
        add_to_schema! prop.name, prop.enum_type
      in :single_option
        add_to_schema! prop.name, prop.vocab_name.to_sym
      else
        add_to_schema! prop.name, prop.kind
      end
    end
  end

  # @return [void]
  def collect_attachments!
    SolutionProperty.in_use.attachments.each do |prop|
      add_to_schema! prop.name, :attachment
      add_to_schema! :"#{prop.name}_remote_url", :url
    end
  end

  # @return [void]
  def collect_free_inputs!
    SolutionProperty.each_free_input do |prop|
      add_to_schema! prop.free_input_name, :string
    end
  end

  # @return [void]
  def collect_associations!
    SolutionProperty.with_model_vocab.each do |prop|
      attr_mapping.remap! prop.name, prop.schema_input_key

      add_to_schema! prop.schema_input_key, prop.kind
    end
  end

  # @return [void]
  def collect_implementations!
    Implementation.each do |impl|
      add_to_schema!(impl.enum, impl.enum_type)

      add_to_schema!(impl.name, impl.type.schema_type_name, nested: true)
    end
  end

  # @return [void]
  def collect_store_model_lists!
    SolutionProperty.store_model_lists.each do |prop|
      model_type = prop.store_model_type_name.constantize

      add_to_schema!(prop.name, model_type.schema_list_name, nested: true)
    end
  end

  def validate!
    failed = false

    schema_attributes.each do |attr, type_expression|
      type = type_expression.safe_constantize

      next if type

      failed = true

      warn "Unable to derive type for #{attr} (#{type_expression})"
    end

    raise "Unable to derive types for one or more attributes" if failed
  end

  # @return [void]
  def finalize!
    template "schema.rb.tt", "app/services/solution_properties/schemas/#{solution_kind}.rb"
  end

  private

  def actual? = solution_kind == :actual

  def draft? = solution_kind == :draft

  def intake? = solution_kind == :intake

  def schema_module_name
    @schema_module_name ||= solution_kind.to_s.camelize
  end

  # @return [:actual, :draft, :intake]
  attr_reader :solution_kind
end
