# frozen_string_literal: true

class ControlledVocabulariesGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  BASE_LABELS = {
    name: "Name / Label",
    term: "Import / Export Term",
    bespoke_filter_position: "Special Filter Position",
    provides: "Special Logic",
    description: "Admin Description",
  }.freeze

  BASE_HINTS = {
    name: "The name of the controlled vocabulary term. This is used as a label in dropdowns and on the frontend",
    term: "The exact-match term used for looking up this specific record when importing from CSV. In most cases it will match the name, but it is used only when importing and exporting in CSV.",
    bespoke_filter_position: "Used for specific ordering of options on the filters on the frontend. Right now, it only applies to Hosting Strategies. If left blank, this option will not appear.",
    provides: "Some controlled vocabulary records need to behave in a certain way within code, like 'Other' options. Specifying a value here will allow that option to behave as expected.",
    description: "Internal usage only. Appears in details about the controlled vocabulary, never on the frontend."
  }.freeze

  def generate_all_controlled_vocabularies!
    ControlledVocabulary.with_model_name.each do |vocab|
      Rails::Generators.invoke("controlled_vocabulary", ["--vocab-name=#{vocab.name}"])
    end
  end

  def generate_connections!
    connections = SolutionProperty.build_raw_connections

    path = Rails.root.join("lib", "frozen_record", "controlled_vocabulary_connections.yml")

    create_file path, YAML.dump(connections)
  end

  def generate_vocab_formtastic!
    path = Rails.root.join("config", "locales", "formtastic.controlled_vocabularies.en.yml")

    locale = build_controlled_vocabulary_formtastic_locale

    create_file path, build_controlled_vocabulary_formtastic_locale
  end

  private

  # @return [String]
  def build_controlled_vocabulary_formtastic_locale
    hints = {}

    labels = {}

    ControlledVocabulary.uses_model.order(model_name: :asc).each do |vocab|
      i18n_key = vocab.model_klass.model_name.i18n_key

      hints[i18n_key] = BASE_HINTS.dup
      labels[i18n_key] = BASE_LABELS.dup
    end

    formtastic = { labels:, hints:, }

    locale = { en: { formtastic:, } }

    YAML.dump(locale.deep_stringify_keys)
  end
end
