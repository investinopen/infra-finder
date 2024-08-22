# frozen_string_literal: true

module SolutionImports
  # Build a context for the import process.
  #
  # @api private
  class ContextBuilder < Support::HookBased::Actor
    include Dry::Effects.Interrupt(:mark_invalid)
    include Dry::Initializer[undefined: false].define -> do
      param :import, Types::SolutionImport

      option :logger, Types.Instance(StoredMessages::Logger)
    end

    standard_execution!

    # @return [SolutionImports::AbstractContext]
    attr_reader :context

    delegate :strategy, :user, to: :import

    # @return [Dry::Monads::Success(SolutionImports::AbstractContext)]
    def call
      run_callbacks :execute do
        @context = yield build!
      end

      Success context
    end

    wrapped_hook! def build
      case strategy
      in "legacy"
        mark_invalid "Legacy imports no longer supported."
      in "eoi"
        eoi_build!
      in "v2"
        v2_build!
      else
        # :nocov:
        mark_invalid "Unsupported strategy: #{strategy}"
        # :nocov:
      end
    end

    wrapped_hook! def eoi_build
      rows = yield parse_csv

      Success SolutionImports::EOI::Context.new(import:, logger:, rows:, user:)
    end

    wrapped_hook! def v2_build
      rows = yield parse_csv

      Success SolutionImports::V2::Context.new(import:, logger:, rows:, user:)
    end

    private

    def parse_csv
      rows = import.source.download do |tmp|
        CSV.table(tmp)
      end
    rescue Errno::ENOENT, CSV::InvalidEncodingError, CSV::MalformedCSVError => e
      # :nocov:
      mark_invalid "Problem parsing CSV: #{e.message}"
      # :nocov:
    else
      Success rows
    end
  end
end
