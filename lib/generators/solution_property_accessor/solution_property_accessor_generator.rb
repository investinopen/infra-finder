# frozen_string_literal: true

class SolutionPropertyAccessorGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  class_option :kind, type: :string

  def generate_klass!
    template "accessor.rb", Rails.root.join("app", "services", "solution_properties", "accessors", "#{file_name}.rb")
  end

  private

  def kind
    @kind ||= options.fetch(:kind) do
      class_name.underscore.to_sym
    end.to_sym
  end
end
