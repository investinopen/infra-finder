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

  private

  def free_input_attrs
    @free_input_attrs ||= Support::Generators::AttrMapping.new.tap do |mapping|
      SolutionProperty.each_free_input do |prop|
        mapping[prop.free_input_name] = :string
      end
    end
  end
end
