# frozen_string_literal: true

module SolutionImports
  module Legacy
    # @abstract
    class EnumParser
      extend Dry::Core::ClassAttributes

      include Dry::Monads[:result]

      defines :enum_type, type: Types.Instance(Dry::Types::Type)

      enum_type Types::Any

      # @param [Object] input
      # @return [Dry::Monads::Success(Object)]
      # @return [Dry::Monads::Failure(void)]
      def call(input)
        parsed = parse(input)

        self.class.enum_type.try(parsed).to_monad
      end

      # @abstract
      # @api private
      # @param [Object] input
      # @return [Object]
      def parse(input)
        # :nocov:
        input
        # :nocov:
      end
    end
  end
end
