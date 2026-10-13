# frozen_string_literal: true

module VOGMutations
  module Arguments
    # @abstract
    class SharedSet < Module
      extend Dry::Core::ClassAttributes
      extend VOGMutations::Arguments::Manipulation

      defines :arguments, type: VOGMutations::Types::SharedArgumentSetMapping

      arguments Dry::Core::Constants::EMPTY_HASH

      class << self
        # @param [Symbol] name
        # @param [Object] type
        # @param [Hash] options
        # @param [Proc, nil] block
        # @return [void]
        def argument(name, type, **options, &block)
          arg = VOGMutations::Arguments::Shared.new(
            name:,
            type:,
            options:,
            block:
          )

          new_args = arguments.merge(name => arg)

          arguments new_args.freeze
        end
      end
    end
  end
end
