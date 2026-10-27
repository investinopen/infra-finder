# frozen_string_literal: true

module Solutions
  # Count the properties on a {Solution} that have no meaningful value.
  #
  # @see Solutions::CountEmptyProperties
  # @see SolutionProperty.counted_when_empty
  # @see SolutionProperties::Accessors::AbstractAccessor#empty?
  class EmptyPropertiesCounter < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :solution, Types::Actual
    end

    standard_execution!

    # @return [Integer]
    attr_reader :count

    # @return [Dry::Monads::Success(Integer)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield count_empty_properties!
      end

      Success count
    end

    wrapped_hook! def prepare
      @count = 0

      super
    end

    wrapped_hook! def count_empty_properties
      @count = SolutionProperty.counted_when_empty.count { _1.accessor.empty?(solution) }

      super
    end
  end
end
