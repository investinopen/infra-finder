# frozen_string_literal: true

require_relative "../../support/system"

class MutationSortGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  # @return [void]
  def sort_mutations!
    return if field_declarations.empty?

    template "mutation_type.rb", target_mutation_type
  end

  private

  # @return [Array<Support::MutationFields::Declaration>] the field definitions in the target mutation file
  def field_declarations
    @field_declarations ||= Support::System["mutation_fields.extract"].()
  end

  # @return [String] the relative path to the target mutation file
  def target_mutation
    "app/graphql/types/mutation_type.rb"
  end

  # @return [Pathname] the path to the target mutation file
  def target_mutation_type
    @target_mutation_type ||= Rails.root.join(target_mutation)
  end
end
