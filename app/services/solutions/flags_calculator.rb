# frozen_string_literal: true

module Solutions
  # Generate and persist {Solutions::Flags} for a given {Solution}.
  class FlagsCalculator < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :solution, Types::Actual
    end

    # @return [Solutions::Flags]
    attr_reader :flags

    standard_execution!

    # @return [Dry::Monads::Success(Solutions::Flags)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield calculate_oss!

        yield calculate_open_access_content!

        yield calculate_free_to_use!

        yield calculate_transparent_governance!

        yield calculate_nonprofit_operated!
      end

      Success flags
    end

    wrapped_hook! def prepare
      @flags = Solutions::Flags.new

      super
    end

    wrapped_hook! def calculate_oss
      flags.oss = false

      super
    end

    wrapped_hook! def calculate_open_access_content
      flags.open_access_content = false

      super
    end

    wrapped_hook! def calculate_free_to_use
      flags.free_to_use = false

      super
    end

    wrapped_hook! def calculate_transparent_governance
      flags.transparent_governance = SecureRandom.random_number(100).even?

      super
    end

    wrapped_hook! def calculate_nonprofit_operated
      flags.nonprofit_operated = solution.nonprofit_status.present?

      super
    end
  end
end
