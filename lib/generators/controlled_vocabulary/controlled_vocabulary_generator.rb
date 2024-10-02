# frozen_string_literal: true

class ControlledVocabularyGenerator < Rails::Generators::Base
  include Dry::Core::Memoizable

  source_root File.expand_path("templates", __dir__)

  class_option :vocab_name, type: :string

  delegate :model_klass, to: :vocab
  delegate :model_name, to: :model_klass
  delegate :i18n_key, to: :model_name

  def apply!
    Rails::Generators.invoke("controlled_vocabulary_record", [vocab.model_name, "--vocab-name=#{vocab_name}"])

    linkages.each do |linkage|
      Rails::Generators.invoke("controlled_vocabulary_link", [linkage.link_model_name, "--kind=#{linkage.kind}", "--vocab-name=#{vocab_name}"])
    end
  end

  def build_spec!
    return unless vocab.uses_model?

    i18n_key = vocab.model_klass.model_name.i18n_key

    path = Rails.root.join("spec", "requests", "admin", "#{i18n_key}_spec.rb")

    template "spec.rb", path
  end

  private

  memoize def linkages
    ControlledVocabularies::Linkage.for_record(vocab_name).values
  end

  memoize def vocab
    ControlledVocabulary.find options[:vocab_name]
  end

  def vocab_name
    options[:vocab_name]
  end
end
