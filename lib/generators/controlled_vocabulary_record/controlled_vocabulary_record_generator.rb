# frozen_string_literal: true

class ControlledVocabularyRecordGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  class_option :vocab_name, type: :string

  def generate_model!
    template "model.rb", Rails.root.join("app", "models", "#{file_name}.rb")
  end

  def generate_admin_resource!
    basename = "#{file_name.to_s.pluralize}.rb"

    path = Rails.root.join("app", "admin", basename)

    template "admin_resource.rb", path
  end

  def generate_factory!
    basename = "#{file_name.to_s.pluralize}.rb"

    path = Rails.root.join("spec", "factories", basename)

    template "factory.rb", path
  end

  def generate_spec!
    path = Rails.root.join("spec", "models", "#{file_name}_spec.rb")

    template "spec.rb", path
  end

  private

  def vocab_name
    @vocab_name ||= options.fetch(:vocab_name)
  end
end
