# frozen_string_literal: true

module SolutionImports
  module Persistence
    # Persist {SolutionIntake} records from an import source.
    #
    # @see SolutionImports::Persistence::PersistIntakes
    class IntakesPersister < SolutionImports::Persistence::BasePersister
      include Dry::Effects::Handler.Cache(:persistence)
      include InfraFinder::Deps[
        persist_each_intake: "solution_imports.persistence.persist_each_intake",
      ]

      define_model_callbacks :each_intake

      around_execute :with_cache

      around_execute :set_import_active!

      around_execute :skip_editor_validations!

      def perform
        context.transient_intakes.each do |intake_row|
          persist_each_intake!(intake_row) do |m|
            m.success do |solution_intake|
              track_import_of!(solution_intake)
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

      include Dry::Matcher.for(:persist_each_intake!, with: Dry::Matcher::ResultMatcher)

      # @return [Dry::Monads::Result]
      def persist_each_intake!(solution_row)
        run_callbacks :each_intake do
          persist_each_intake.(solution_row)
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
