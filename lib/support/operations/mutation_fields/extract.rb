# frozen_string_literal: true

module Support
  module MutationFields
    # Extract mutation field declarations from a GraphQL type definition file.
    class Extract
      # Match a field declaration
      FIELD_PATTERN = /\A\s*field\s+:(\w+),\s+mutation:\s+\w+/

      # A pattern to extract the name from a field declaration
      FIELD_NAME_PATTERN = /\A\s*field\s+:(\w+)/

      # @return [<Support::MutationFields::Declaration>] the mutation fields extracted from the target mutation file
      def call
        source = target_mutation_type.read

        lines = source.lines

        field_declarations = []

        lines.each_with_index do |line, index|
          next unless line.strip.match?(FIELD_PATTERN)

          content = line.strip

          name = line[FIELD_NAME_PATTERN, 1]

          declaration = Support::MutationFields::Declaration.new(name:, content:, index:)

          field_declarations << declaration
        end

        field_declarations.sort!

        return field_declarations
      end

      private

      # @!attribute [r] target_mutation_type
      # @return [Pathname]
      def target_mutation_type
        @target_mutation_type ||= Rails.root.join("app", "graphql", "types", "mutation_type.rb")
      end
    end
  end
end
