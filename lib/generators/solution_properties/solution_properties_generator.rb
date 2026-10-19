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
  def generate_graphql_implementation_types!
    Implementation.each do |implementation|
      @implementation = implementation

      template "graphql_implementation_type.rb", Rails.root.join("app", "graphql", "types", "#{graphql_implementation_type_name(implementation).underscore}.rb")
    end
  end

  # @return [void]
  def generate_graphql_implementation_input_types!
    Implementation.each do |implementation|
      @implementation = implementation

      template "graphql_implementation_input_type.rb", Rails.root.join("app", "graphql", "types", "#{graphql_implementation_input_type_name(implementation).underscore}.rb")
    end
  end

  # @return [void]
  def generate_graphql_interface!
    template "graphql_interface.rb", Rails.root.join("app", "graphql", "types", "solution_interface_type.rb")
  end

  # @return [void]
  def generate_graphql_structured_input_types!
    structured_model_types.each do |model_type|
      @structured_model_type = model_type

      template "graphql_structured_input_type.rb", Rails.root.join("app", "graphql", "types", "#{graphql_structured_input_type_name(model_type).underscore}.rb")
    end
  end

  # One shared argument set per solution kind, holding the properties that kind can set,
  # for its mutations to include with `shared_argument_set`.
  #
  # @return [void]
  def generate_graphql_argument_sets!
    { actual: "Solution", draft: "SolutionDraft", intake: "SolutionIntake" }.each do |kind, model_name|
      @input_kind = kind
      @input_model_name = model_name

      template "graphql_argument_set.rb", Rails.root.join("app", "graphql", "mutations", "shared", "#{model_name.underscore}_attributes.rb")
    end
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
      ["::GraphQL::Types::Boolean", true]
    in :date
      ["::GraphQL::Types::ISO8601Date", true]
    in :integer
      ["Integer", true]
    in :money
      ["::Types::MoneyType", true]
    in :enum
      ["::Types::#{prop.enum_type.to_s.camelize}Type", true]
    in :implementation
      ["::Types::#{graphql_implementation_type_name(prop.implementation)}", false]
    in :implementation_enum
      ["::Types::#{graphql_implementation_status_enum_for(prop.implementation)[:class_name]}", true]
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

  # Properties a solution kind can set through the API. Implementation links are
  # part of their implementation.
  #
  # @param [Solutions::Types::Kind] kind
  # @return [<SolutionProperty>]
  def graphql_input_properties(kind)
    SolutionProperty.in_use.to_a.sort_by(&:attribute_name).select do |prop|
      next false if prop.kind.in?(%i[implementation_property standard timestamp])

      next false if prop.only.present? && prop.only != kind

      prop.association_name.present? ? writable_association?(prop, kind) : prop.exists_for?(kind)
    end
  end

  # @param [SolutionProperty] prop
  # @return [(String, String, String, String)]
  def graphql_association_argument_for(prop)
    reflection = SolutionProperty.solution_record_for(@input_kind).class.reflect_on_association(prop.association_name.to_sym)

    loads = "::#{reflection.klass.graphql_node_type_name}"

    if reflection.collection?
      ["#{prop.association_name.singularize}_ids", "[::GraphQL::Types::ID, { null: false }]", loads, prop.association_name]
    else
      ["#{prop.association_name}_id", "::GraphQL::Types::ID", loads, prop.association_name]
    end
  end

  # Drafts reach their provider through their solution, so they cannot set it.
  #
  # @param [SolutionProperty] prop
  # @param [Solutions::Types::Kind] kind
  # @return [Boolean]
  def writable_association?(prop, kind)
    reflection = SolutionProperty.solution_record_for(kind).class.reflect_on_association(prop.association_name.to_sym)

    reflection.present? && !reflection.through_reflection?
  end

  # @param [SolutionProperty] prop
  # @return [(String, String, String, String), (String, String, nil)] the argument name and its
  #   GraphQL type, then for arguments that load records the type loaded and the attribute it is
  #   assigned to, or `nil` otherwise
  def graphql_input_argument_for(prop)
    return graphql_association_argument_for(prop) if prop.association_name.present?

    case prop.kind
    in :single_option if prop.vocab.uses_model?
      ["#{prop.attribute_name}_id", "::GraphQL::Types::ID", "::Types::#{prop.vocab.model_name}Type", prop.attribute_name]
    in :multi_option
      ["#{prop.attribute_name.to_s.singularize}_ids", "[::GraphQL::Types::ID, { null: false }]", "::Types::#{prop.vocab.model_name}Type", prop.attribute_name]
    in :money
      [prop.attribute_name, "String", nil]
    in :implementation
      [prop.name, "::Types::#{graphql_implementation_input_type_name(prop.implementation)}", nil]
    in :store_model_list
      [prop.attribute_name, "[::Types::#{graphql_structured_input_type_name(prop.store_model_type_name.constantize)}, { null: false }]", nil]
    else
      [graphql_field_name_for(prop), graphql_field_type_for(prop).first, nil]
    end
  end

  # Lists and NOT NULL columns refuse an explicit `null`, so it fails validation
  # rather than in the database.
  #
  # @param [SolutionProperty] prop
  # @return [Boolean]
  def graphql_input_allows_null?(prop)
    return false if prop.kind.in?(%i[multi_option store_model_list implementation])

    column_name = prop.kind == :money ? "#{prop.attribute_name}_cents" : prop.attribute_name.to_s

    column = SolutionProperty.solution_record_for(@input_kind).class.columns_hash[column_name]

    column.nil? || column.null
  end

  # @param [Implementation] implementation
  # @return [String]
  def graphql_implementation_input_type_name(implementation)
    "#{implementation.name.camelize}ImplementationInputType"
  end

  # @param [Class<Structured::Model>] model_type
  # @return [String]
  def graphql_structured_input_type_name(model_type)
    "#{model_type.name.gsub("::", "")}InputType"
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

    enum_props.map do |prop|
      { file_name: "#{prop.enum_type}_type", class_name: "#{prop.enum_type.to_s.camelize}Type", description: prop.be_label, values: ApplicationRecord.pg_enum_values(prop.enum_type) }
    end.concat(Implementation.all.map { graphql_implementation_status_enum_for(_1) }.uniq).push(
      { file_name: "solution_kind_type", class_name: "SolutionKindType", description: "Which kind of solution record: a published solution, a draft, or an intake", values: ApplicationRecord.pg_enum_values("solution_kind") }
    )
  end

  # Most implementations share `implementation_status`; pricing has its own.
  #
  # @param [Implementation] implementation
  # @return [Hash]
  def graphql_implementation_status_enum_for(implementation)
    sql_type = ::Solution.columns_hash.fetch(implementation.enum).sql_type

    { file_name: "#{sql_type}_type", class_name: "#{sql_type.camelize}Type", description: "The status of one of a solution's implementations", values: ApplicationRecord.pg_enum_values(sql_type) }
  end

  # @param [Implementation] implementation
  # @return [String]
  def graphql_implementation_type_name(implementation)
    "#{implementation.name.camelize}ImplementationType"
  end

  # @param [Implementation] implementation
  # @return [<(String, String)>] attribute names and GraphQL types
  def graphql_implementation_fields_for(implementation)
    implementation.type.attribute_types.map do |name, type|
      graphql_type =
        case name
        when "links" then "[::Types::ImplementationLinkType, { null: false }]"
        when "link" then "::Types::ImplementationLinkType"
        else
          type.type == :boolean ? "Boolean" : "String"
        end

      [name, graphql_type]
    end
  end

  def free_input_attrs
    @free_input_attrs ||= Support::Generators::AttrMapping.new.tap do |mapping|
      SolutionProperty.each_free_input do |prop|
        mapping[prop.free_input_name] = :string
      end
    end
  end
end
