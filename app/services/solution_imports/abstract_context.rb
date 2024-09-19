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

    include Dry::Effects::Handler.State(:extracted_providers)
    include Dry::Effects::Handler.State(:extracted_solutions)
    include Dry::Effects::Handler.State(:providers_count)
    include Dry::Effects::Handler.State(:solutions_count)

    option :import, Types::SolutionImport
    option :logger, Types.Instance(StoredMessages::Logger)
    option :user, Types::User.optional, optional: true

    defines :strategy, type: Types::Strategy.optional

    define_model_callbacks :extraction, :persistence

    # @return [Integer]
    attr_accessor :providers_count

    # @return [Integer]
    attr_accessor :solutions_count

    # @return [<SolutionImports::Transient::ProviderRow>]
    attr_reader :transient_providers

    # @return [<SolutionImports::Transient::SolutionRow>]
    attr_reader :transient_solutions

    def initialize(...)
      super

      @providers_count = 0
      @solutions_count = 0

      @transient_providers = []
      @transient_solutions = []
    end

    # @return [SolutionImports::Types::Strategy]
    def strategy
      self.class.strategy
    end

    def to_finalize
      { providers_count:, solutions_count:, }
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

    around_extraction :collect_providers!
    around_extraction :collect_solutions!

    around_persistence :track_providers_count!
    around_persistence :track_solutions_count!

    private

    # @return [void]
    def collect_providers!
      collected, _ = with_extracted_providers([]) do
        yield
      end

      transient_providers.concat(collected)
    end

    # @return [void]
    def collect_solutions!
      collected, _ = with_extracted_solutions([]) do
        yield
      end

      transient_solutions.concat(collected)
    end

    # @return [void]
    def track_providers_count!
      @providers_count, _ = with_providers_count(0) do
        yield
      end
    end

    # @return [void]
    def track_solutions_count!
      @solutions_count, _ = with_solutions_count(0) do
        yield
      end
    end

    module ProcessesCSVRows
      extend ActiveSupport::Concern

      included do
        include Dry::Effects::Handler.Reader(:row_number)

        option :rows, Types.Instance(CSV::Table)
      end

      # @yield [row] yield each row with the row_number in context
      # @yieldparam [CSV::Row] row
      # @yieldreturn [void]
      # @return [void]
      def each_row
        # :nocov:
        return enum_for(__method__) unless block_given?
        # :nocov:

        rows.each_with_index do |row, index|
          number = index + 1

          with_row_number number do
            logger.tagged("[row:#{number}]") do
              if empty_row?(row)
                logger.debug("Skipping empty row")
              else
                yield row
              end
            end
          end
        end
      end

      # @param [CSV::Row] row
      def empty_row?(row)
        row.fields.compact.blank?
      end
    end
  end
end
