# frozen_string_literal: true

class SolutionPropertyAccessorsGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  def generate_accessors!
    SolutionPropertyKind.each do |spk|
      class_name = spk.kind.to_s.classify

      Rails::Generators.invoke("solution_property_accessor", [class_name, "--kind=#{spk.kind}"])
    end
  end
end
