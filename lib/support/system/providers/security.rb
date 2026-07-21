# frozen_string_literal: true

Support::System.register_provider(:security) do
  prepare do
    # require "third_party/db"
  end

  start do
    register :node_verifier, memoize: true do
      ActiveSupport::MessageVerifier.new SecurityConfig.node_salt, digest: "SHA256"
    end
  end
end
