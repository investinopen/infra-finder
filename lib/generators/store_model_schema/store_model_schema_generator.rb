# frozen_string_literal: true

class StoreModelSchemaGenerator < Rails::Generators::NamedBase
  include Support::Generators::HasAttrMapping
  include Support::Generators::HasExistingKlass
  include Support::Generators::HasTypeMapping
  include Support::Generators::FormattedNaming
  include Support::Generators::Quoting
  include Support::Generators::WritesSchema

  source_root File.expand_path("templates", __dir__)

  fallback_type "Inputs::Types::Any"

  map_types!(
    boolean: "Inputs::Types::Attributes::Bool",
    date: "Inputs::Types::Attributes::Date",
    integer: "Inputs::Types::Attributes::Integer",
    string: "Inputs::Types::Attributes::String"
  )

  # @return [void]
  def collect_attributes!
    aliased_attributes.each do |new, old|
      attr_mapping[new.to_sym] = old.to_sym
    end

    klass.attribute_types.each do |attr, type|
      schema_attributes[:"#{attr}?"] = type_expression_for(type)

      attr_mapping.nested!(attr) if store_model_type?(type)
    end
  end

  # @return [void]
  def generate_schema!
    template "schema.rb.tt", klass.schema_namespace_path(root: Rails.root.join("app", "services"))
  end

  private

  def aliased_attributes
    @aliased_attributes ||= klass.attribute_aliases.transform_keys(&:to_sym).transform_values(&:to_sym)
  end

  # @return [Hash<Symbol, String>]
  def schema_attributes
    @schema_attributes ||= klass.attribute_types.each_with_object({}) do |(attr, type), hash|
      hash[:"#{attr}?"] = type_expression_for(type)
    end
  end
end
