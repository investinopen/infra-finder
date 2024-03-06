# frozen_string_literal: true

module SolutionImports
  # @abstract
  class AbstractContext
    extend ActiveModel::Callbacks
    extend Dry::Core::ClassAttributes
    extend Dry::Initializer

    include Dry::Core::Memoizable

    include Dry::Effects::Handler.Reader(:context)
    include Dry::Effects::Handler.Reader(:strategy)
    include Dry::Effects::Handler.Reader(:logger)
    include Dry::Effects::Handler.Resolve

    include Dry::Effects::Handler.State(:extracted_organizations)
    include Dry::Effects::Handler.State(:extracted_solutions)
    include Dry::Effects::Handler.State(:organizations_count)
    include Dry::Effects::Handler.State(:solutions_count)

    option :import, Types::SolutionImport
    option :logger, Types.Instance(StoredMessages::Logger)
    option :user, Types::User.optional, optional: true

    defines :strategy, type: Types::Strategy.optional

    define_model_callbacks :extraction, :persistence

    # @return [Integer]
    attr_accessor :organizations_count

    # @return [Integer]
    attr_accessor :solutions_count

    # @return [<SolutionImports::Transient::OrganizationRow>]
    attr_reader :transient_organizations

    # @return [<SolutionImports::Transient::SolutionRow>]
    attr_reader :transient_solutions

    def initialize(...)
      super

      @organizations_count = 0
      @solutions_count = 0

      @transient_organizations = []
      @transient_solutions = []
    end

    # @return [SolutionImports::Types::Strategy]
    def strategy
      self.class.strategy
    end

    def to_finalize
      { organizations_count:, solutions_count:, }
    end

    # @return [{ Symbol => Object }]
    def to_provisions
      { import:, user:, }
    end

    # @api private
    # @return [void]
    def wrap
      with_context self do
        with_strategy strategy do
          with_logger logger do
            provide **to_provisions do
              yield
            end
          end
        end
      end
    end

    # @!group Steps

    # @api private
    # @return [void]
    def wrap_extraction!
      wrap do
        run_callbacks :extraction do
          yield
        end
      end
    end

    # @api private
    # @return [void]
    def wrap_persistence!
      wrap do
        run_callbacks :persistence do
          yield
        end
      end
    end

    # @!endgroup

    around_extraction :collect_organizations!
    around_extraction :collect_solutions!

    around_persistence :track_organizations_count!
    around_persistence :track_solutions_count!

    private

    # @return [void]
    def collect_organizations!
      collected, _ = with_extracted_organizations([]) do
        yield
      end

      transient_organizations.concat(collected)
    end

    # @return [void]
    def collect_solutions!
      collected, _ = with_extracted_solutions([]) do
        yield
      end

      transient_solutions.concat(collected)
    end

    # @return [void]
    def track_organizations_count!
      @organizations_count, _ = with_organizations_count(0) do
        yield
      end
    end

    # @return [void]
    def track_solutions_count!
      @solutions_count, _ = with_solutions_count(0) do
        yield
      end
    end
  end
end
