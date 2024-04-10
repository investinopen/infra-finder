# frozen_string_literal: true

module Comparisons
  module Sharing
    # @see Comparisons::Sharing::Regenerate
    class Regenerator < ::Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :comparison, Types::Comparison
      end

      standard_execution!

      include InfraFinder::Deps[
        generate: "comparisons.sharing.generate",
      ]

      # @return [ComparisonShare]
      attr_reader :comparison_share

      # @return [String, nil]
      attr_reader :fingerprint

      # @return [Hash]
      attr_reader :share_options

      def call
        run_callbacks :execute do
          yield prepare!

          yield maybe_generate!

          yield update_comparison!
        end

        Success comparison
      end

      wrapped_hook! def prepare
        @comparison_share = nil
        @fingerprint = nil

        @share_options = comparison.to_share_options

        super
      end

      wrapped_hook! def maybe_generate
        generate.(**share_options) do |m|
          m.success do |comparison_share|
            @comparison_share = comparison_share
            @fingerprint = comparison_share.fingerprint
          end

          m.failure do
            # Intentionally left blank.
          end
        end

        super
      end

      wrapped_hook! def update_comparison
        if comparison.fingerprint != fingerprint
          comparison.update_columns(fingerprint:)

          comparison.reload_comparison_share
        end

        super
      end
    end
  end
end
