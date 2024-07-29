# frozen_string_literal: true

class ControlledVocabulariesGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

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
end
