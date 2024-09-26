# frozen_string_literal: true

# Combine solution property sets within `lib/properties`.
class SolutionPropertiesGenerator < Rails::Generators::Base
  PROPERTIES_PATH = Rails.root.join("lib", "frozen_record", "solution_properties.yml")

  PROPERTY_SET_PATH = Rails.root.join("lib", "properties").freeze

  PROP_NAMES = %w[base implementations].freeze

  STRIP_USELESS_NEWLINES = /\s+$/m

  def compose_properties
    combined = load_properties

    content = combined.to_yaml.gsub(STRIP_USELESS_NEWLINES, "")

    create_file PROPERTIES_PATH, content
  end

  private

  def load_properties
    PROP_NAMES.each_with_object([]) do |name, combined|
      filename = "#{name}.yml"

      props = YAML.load_file PROPERTY_SET_PATH.join(filename)

      combined.concat props
    end
  end
end
