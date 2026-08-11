# frozen_string_literal: true

class SchemasGenerator < Rails::Generators::Base
  include SolutionProperties::Generators

  source_root File.expand_path("templates", __dir__)

  # @return [void]
  def generate_for_each_model!
    Rails::Generators.invoke("store_model_schema", ["Implementations::Link"])

    implementations.each do |implementation|
      Rails::Generators.invoke("store_model_schema", [implementation.type_name])
    end

    structured_model_type_names.each do |class_name|
      Rails::Generators.invoke("store_model_schema", [class_name])
    end

    SOLUTION_MODELS.each do |class_name|
      Rails::Generators.invoke("solution_property_schema", [class_name])
    end
  end
end
