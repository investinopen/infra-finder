# frozen_string_literal: true

module Types
  # @see SolutionInterface#complete?
  module CompletableType
    include Types::BaseInterface

    description <<~TEXT
    A solution, draft, or intake, which is complete when every required property has a value.
    TEXT

    field :complete, Boolean, null: true, method: :complete? do
      description <<~TEXT
      Whether every required property has a value, as of the last save. Null when not yet checked.
      TEXT
    end

    field :missing_properties, [String, { null: false }], null: true do
      description <<~TEXT
      The required properties without a value, named by the input fields that set them
      (for example, `solutionCategoryIds`). Null when not yet checked.
      TEXT
    end

    # @return [<String>, nil]
    def missing_properties
      argument_set = mutation_for(object).argument_set

      object.missing_properties&.map do |attribute|
        argument_set.normalize_attribute_path([attribute.to_sym]).join(?.)
      end
    end

    private

    # The mutation whose arguments name this record's fields, matching the paths in its errors.
    #
    # @param [Solution, SolutionDraft, SolutionIntake] record
    # @return [Class<Mutations::BaseMutation>]
    def mutation_for(record)
      case record
      when ::Solution then ::Mutations::MutateSolution
      when ::SolutionDraft then ::Mutations::MutateSolutionDraft
      when ::SolutionIntake then ::Mutations::MutateSolutionIntake
      end
    end
  end
end
