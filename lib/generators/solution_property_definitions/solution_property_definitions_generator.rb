# frozen_string_literal: true

# Combine solution property sets within `lib/properties`.
class SolutionPropertyDefinitionsGenerator < Rails::Generators::Base
  include SolutionProperties::Generators

  source_root File.expand_path("templates", __dir__)

  PROPERTIES_PATH = Rails.root.join("lib", "frozen_record", "solution_properties.yml")

  PROPERTY_SET_PATH = Rails.root.join("lib", "properties").freeze

  PROP_NAMES = %w[
    base
    blurbs
    implementation_enums
    implementation_properties
    implementations
    other_options
    store_model_inputs
    store_model_lists
    vocabs
  ].freeze

  STRIP_USELESS_NEWLINES = /\s+$/m

  # @return [void]
  def compose_properties!
    combined = load_properties

    content = combined.to_yaml.gsub(STRIP_USELESS_NEWLINES, "")

    create_file PROPERTIES_PATH, content

    reload_records!
  end

  private

  def load_properties
    PROP_NAMES.each_with_object([]) do |name, combined|
      filename = "#{name}.yml"

      props = YAML.load_file PROPERTY_SET_PATH.join(filename)

      combined.concat props
    end.sort_by do |prop|
      code = prop.fetch("code", 100_000_000)
      name = prop.fetch("name")

      [code, name]
    end
  end
end
