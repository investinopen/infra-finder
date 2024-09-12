# frozen_string_literal: true

module SolutionImports
  module Persistence
    # Persist transient {Solution} records from an import source.
    #
    # @see SolutionImports::Persistence::PersistSolutions
    class SolutionPersister < SolutionImports::Persistence::BasePersister
      include Dry::Effects::Handler.Cache(:persistence)
      include InfraFinder::Deps[
        persist_each_solution: "solution_imports.persistence.persist_each_solution",
      ]

      define_model_callbacks :each_solution

      around_execute :with_cache

      around_execute :set_import_active!

      around_execute :skip_editor_validations!

      def perform
        context.transient_solutions.each do |solution_row|
          persist_each_solution!(solution_row) do |m|
            m.success do |solution|
              track_import_of!(solution)
            end

            m.failure do
              # :nocov:
              raise "Something went wrong"
              # :nocov:
            end
          end
        end

        super
      end

      include Dry::Matcher.for(:persist_each_solution!, with: Dry::Matcher::ResultMatcher)

      # @return [Dry::Monads::Result]
      def persist_each_solution!(solution_row)
        run_callbacks :each_solution do
          persist_each_solution.(solution_row)
        end
      end

      # @return [void]
      def set_import_active!
        Solutions::Validations.importing! do
          yield
        end
      end

      # @return [void]
      def skip_editor_validations!
        Solutions::Validations.skip_editor_validations! do
          yield
        end
      end
    end
  end
end
