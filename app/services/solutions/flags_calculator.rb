# frozen_string_literal: true

module Solutions
  # Generate and persist {Solutions::Flags} for a given {Solution}.
  class FlagsCalculator < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :solution, Types::Actual
    end

    # @return [Solutions::Flags]
    attr_reader :flags

    # @return [Solutions::FlagsCalculator::SolutionProxy]
    attr_reader :proxy

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

      @proxy = SolutionProxy.new(solution)

      super
    end

    wrapped_hook! def calculate_oss
      flags.oss = proxy.oss?

      super
    end

    wrapped_hook! def calculate_open_access_content
      flags.open_access_content = proxy.open_access_content?

      super
    end

    wrapped_hook! def calculate_free_to_use
      flags.free_to_use = proxy.free_to_use?

      super
    end

    wrapped_hook! def calculate_transparent_governance
      flags.transparent_governance = proxy.transparent_governance?

      super
    end

    wrapped_hook! def calculate_nonprofit_operated
      flags.nonprofit_operated = proxy.nonprofit_operated?

      super
    end

    # @api private
    class SolutionProxy
      include Dry::Initializer[undefined: false].define -> do
        param :solution, Types::Actual
      end

      delegate_missing_to :solution

      # @!group Flags

      def oss?
        oss_code_license_ok? && oss_code_repository_ok?
      end

      def open_access_content?
        content_licenses.exists?
      end

      def free_to_use?
        (pricing_available? && pricing_has_url?) || pricing_no_direct_costs?
      end

      def transparent_governance?
        governance_structure_available_with_url? && bylaws_available_with_url?
      end

      def nonprofit_operated?
        business_forms.exists? && business_forms.all?(&:counts_for_nonprofit_operated?)
      end

      # @!endgroup

      # @!group Conditions

      def oss_code_license_ok?
        licenses.exists? && code_license_has_url?
      end

      def oss_code_repository_ok?
        code_repository_available? && code_repository.has_url?
      end

      # @!endgroup
    end
  end
end
