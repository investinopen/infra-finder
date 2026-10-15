# frozen_string_literal: true

class SolutionPropertiesGenerator < Rails::Generators::Base
  include SolutionProperties::Generators

  source_root File.expand_path("templates", __dir__)

  # @return [void]
  def regenerate_definitions!
    Rails::Generators.invoke("solution_property_definitions")

    reload_records!
  end

  # @return [void]
  def regenerate_schemas!
    Rails::Generators.invoke("schemas")
  end

  # @return [void]
  def generate_has_implementations!
    template "has_implementations.rb.tt", Rails.root.join("app", "services", "solution_properties", "has_implementations.rb")
  end

  # @return [void]
  def generate_has_store_model_lists!
    template "has_store_model_lists.rb.tt", Rails.root.join("app", "services", "solution_properties", "has_store_model_lists.rb")
  end

  # @return [void]
  def generate_free_inputs!
    template "free_inputs.rb.tt", Rails.root.join("app", "services", "solution_properties", "free_inputs.rb")
  end

  def regenerate_property_sets!
    Rails::Generators.invoke("v2_property_set")
  end

  # @return [void]
  def generate_graphql_enums!
    graphql_enums.each do |enum|
      @graphql_enum = enum

      template "graphql_enum.rb", Rails.root.join("app", "graphql", "types", "#{enum[:file_name]}.rb")
    end
  end

  # @return [void]
  def generate_graphql_structured_types!
    structured_model_types.each do |model_type|
      @structured_model_type = model_type

      template "graphql_structured_type.rb", Rails.root.join("app", "graphql", "types", "#{graphql_structured_type_name(model_type).underscore}.rb")
    end
  end

  # @return [void]
  def generate_graphql_interface!
    template "graphql_interface.rb", Rails.root.join("app", "graphql", "types", "solution_interface_type.rb")
  end

  private

  # Properties shared by solutions, drafts, and intakes. Timestamps are left
  # to `HasDefaultTimestamps` and the solution types.
  #
  # @see SolutionProperty#graphql_field_name
  # @return [<SolutionProperty>]
  def graphql_interface_properties
    SolutionProperty.in_use.to_a.sort_by(&:attribute_name).select do |prop|
      prop.graphql_field_name.present? && prop.only.blank? && prop.kind != :timestamp
    end
  end

  # @param [SolutionProperty] prop
  # @return [(String, Boolean)] the GraphQL type expression and nullability
  def graphql_field_type_for(prop)
    return graphql_association_type_for(prop) if prop.association_name.present?

    case prop.kind
    in :blurb | :contact | :email | :other_option | :store_model_input | :string | :url
      ["String", true]
    in :boolean
      ["Boolean", true]
    in :date
      ["GraphQL::Types::ISO8601Date", true]
    in :integer
      ["Integer", true]
    in :money
      ["::Types::MoneyType", true]
    in :enum
      ["::Types::#{prop.enum_type.to_s.camelize}Type", true]
    in :implementation
      ["::Types::SolutionImplementationType", false]
    in :store_model_list
      ["[::Types::#{graphql_structured_type_name(prop.store_model_type_name.constantize)}, { null: false }]", false]
    in :single_option if prop.vocab.uses_model?
      ["::Types::#{prop.vocab.model_name}Type", true]
    in :single_option
      ["String", true]
    in :multi_option
      ["[::Types::#{prop.vocab.model_name}Type, { null: false }]", false]
    end
  end

  # @param [SolutionProperty] prop
  # @return [(String, Boolean)]
  def graphql_association_type_for(prop)
    reflection = ::Solution.reflect_on_association(prop.association_name.to_sym)

    type_name = "::#{reflection.klass.graphql_node_type_name}"

    reflection.collection? ? ["[\"#{type_name}\", { null: false }]", false] : ["\"#{type_name}\"", true]
  end

  # @param [SolutionProperty] prop
  # @return [String]
  def graphql_field_name_for(prop)
    prop.graphql_field_name.underscore
  end

  # @param [SolutionProperty] prop
  # @return [String]
  def graphql_description_for(prop)
    [prop.be_label, prop.description].compact_blank.uniq.join(". ").squish
  end

  # @param [Class<Structured::Model>] model_type
  # @return [String]
  def graphql_structured_type_name(model_type)
    "#{model_type.name.gsub("::", "")}Type"
  end

  # @param [Class<Structured::Model>] model_type
  # @return [<(String, String)>] attribute names and GraphQL types
  def graphql_structured_fields_for(model_type)
    model_type.attribute_types.filter_map do |name, type|
      graphql_type =
        case type.type
        when :string, :text then "String"
        when :integer then "Integer"
        when :boolean then "Boolean"
        when :date then "GraphQL::Types::ISO8601Date"
        when :decimal, :float then "Float"
        end

      [name, graphql_type] if graphql_type
    end
  end

  # @return [<Hash>]
  def graphql_enums
    enum_props = SolutionProperty.in_use.where(kind: :enum).to_a

    implementation_values = Implementation.pluck(:enum).flat_map do |column|
      ApplicationRecord.pg_enum_values(::Solution.columns_hash.fetch(column).sql_type)
    end.uniq

    enum_props.map do |prop|
      { file_name: "#{prop.enum_type}_type", class_name: "#{prop.enum_type.to_s.camelize}Type", description: prop.be_label, values: ApplicationRecord.pg_enum_values(prop.enum_type) }
    end.push(
      { file_name: "implementation_status_type", class_name: "ImplementationStatusType", description: "The status of one of a solution's implementations", values: implementation_values },
      { file_name: "solution_kind_type", class_name: "SolutionKindType", description: "Which kind of solution record: a published solution, a draft, or an intake", values: ApplicationRecord.pg_enum_values("solution_kind") }
    )
  end

  def free_input_attrs
    @free_input_attrs ||= Support::Generators::AttrMapping.new.tap do |mapping|
      SolutionProperty.each_free_input do |prop|
        mapping[prop.free_input_name] = :string
      end
    end
  end
end
