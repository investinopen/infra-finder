# frozen_string_literal: true

class ControlledVocabularyLinkGenerator < Rails::Generators::NamedBase
  include Dry::Core::Memoizable

  source_root File.expand_path("templates", __dir__)

  class_option :kind, type: :string, desc: "draft|actual", default: "actual"

  class_option :vocab_name, type: :string

  def generate_model!
    template "model.rb", Rails.root.join("app", "models", "#{file_name}.rb")
  end

  private

  memoize def linkage
    ControlledVocabularies::Linkage.for_link(vocab_name, solution_kind)
  end

  memoize def solution_kind
    ControlledVocabularies::Types::SourceKind[options[:kind]]
  end

  def vocab_name
    options[:vocab_name]
  end
end
