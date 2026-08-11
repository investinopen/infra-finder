# frozen_string_literal: true

module SolutionProperties
  module Generators
    extend ActiveSupport::Concern

    include ::Support::Generators::Quoting

    # The names of models that are either solutions or solution-adjacent.
    #
    # @return [<String>]
    SOLUTION_MODELS = %w[
      Solution
      SolutionDraft
      SolutionIntake
    ].freeze

    private

    # @return [FrozenRecord::Scope<Implementation>]
    def implementations
      Implementation.order(name: :asc)
    end

    # @return [void]
    def reload_records!
      [
        Implementation,
        SolutionProperty,
      ].each do |klass|
        klass.load_records(force: true)
      end

      @structured_model_types = nil
      @structured_model_type_names = nil
    end

    # @return [FrozenRecord::Scope<SolutionProperty>]
    def store_model_lists
      SolutionProperty.store_model_lists.order(name: :asc)
    end

    # @return [<Class<Structured::Model>>]
    def structured_model_types
      @structured_model_types ||= structured_model_type_names.map(&:constantize)
    end

    # @return [<String>]
    def structured_model_type_names
      @structured_model_type_names ||= SolutionProperty.store_model_lists.pluck(:store_model_type_name).uniq.sort
    end
  end
end
