# frozen_string_literal: true

return unless defined?(::RuboCop)

module RuboCop
  module Cop
    module RSpec
      # This enforces that we don't want or need RSpec files to have `require "rails_helper"` at the top.
      # All files depend on the Rails environment, so we do that automatically and it just clutters things up.
      class NoRequireRailsHelper < RuboCop::Cop::Base
        extend AutoCorrector

        MSG = %[Don't `%<method>s` "%<helper>s".]
        REQUIRE_METHODS = Set.new(%i[require require_relative]).freeze
        HELPER_FILES = Set.new(%w[rails_helper spec_helper]).freeze
        RESTRICT_ON_SEND = REQUIRE_METHODS

        # @!method require_helper_call?(node)
        def_node_matcher :require_helper_call?, <<~PATTERN
          (send {nil? (const _ :Kernel)} %REQUIRE_METHODS _)
        PATTERN

        def on_send(node)
          return unless require_helper_call?(node)

          file = node.first_argument.str_content

          return unless HELPER_FILES.include? file

          add_offense(node, message: format(MSG, method: node.method_name, helper: file)) do |corrector|
            corrector.replace(node, "")
          end
        end
      end
    end
  end
end
