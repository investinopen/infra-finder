# frozen_string_literal: true

module CLI
  module Commands
    # @abstract
    class AbstractCommand < Dry::CLI::Command
      extend Dry::Core::ClassAttributes

      include Dry::Monads[:result]
      include Support::CallsCommonOperation

      defines :contract, type: Types.Instance(Dry::Validation::Contract).optional

      defines :contract_path, type: Types::String.optional

      defines :uses_contract, type: Types::Bool

      uses_contract false

      CONTRACT_UNSPECIFIED = Object.new.freeze

      # @return [void]
      def call(**args)
        case validate!(**args)
        in Success()
          perform!(**args)
        else
          # simplecov:disable
          warn "Validation failed, cannot proceed"

          exit 1
          # simplecov:enable
        end
      end

      private

      # @abstract
      # @return [void]
      def perform!(**args)
        # simplecov:disable
        raise NotImplementedError, "Subclasses must implement the `#perform!` method"
        # simplecov:enable
      end

      def validate!(**args)
        return Success() unless uses_contract?

        result = contract.(**args)

        return Success() if result.success?

        warn "Problem with CLI args!"

        result.errors.messages.each do |message|
          warn "  - #{message.path.join(?.)}: #{message.text}"
        end

        Failure(:invalid_args)
      end

      def uses_contract? = self.class.uses_contract

      def contract = self.class.contract

      def contract_path = self.class.contract_path

      class << self
        def default_contract_path
          name.sub(/\ACLI::Commands::/, "CLI::Contracts::").underscore.tr(?/, ?.)
        end

        def find_contract(path) = Common::Container[path]

        def uses_contract? = uses_contract

        def uses_contract!(input = CONTRACT_UNSPECIFIED)
          case input
          in CONTRACT_UNSPECIFIED
            uses_contract!(default_contract_path)
          in String => path
            uses_contract! find_contract(path)

            contract_path path
          in Dry::Validation::Contract => contract_instance
            contract contract_instance
            uses_contract true
          else
            # simplecov:disable
            raise ArgumentError, "Invalid argument for `uses_contract!`: #{input.inspect}"
            # simplecov:enable
          end
        end
      end
    end
  end
end
