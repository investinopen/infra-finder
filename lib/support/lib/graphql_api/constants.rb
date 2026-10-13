# frozen_string_literal: true

module Support
  module GraphQLAPI
    module Constants
      # The default perPage size when not otherwise specified
      DEFAULT_PER_PAGE_SIZE = 25

      # The maximum amount to allow per page (used in several places)
      MAX_PER_PAGE_SIZE = 200

      # The maximum query depth. The standard introspection query needs about 13.
      MAX_DEPTH = 20

      # The maximum query complexity. Provisional; tune once real SPA queries exist.
      MAX_COMPLEXITY = 10_000
    end
  end
end
