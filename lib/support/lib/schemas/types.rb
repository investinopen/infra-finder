# frozen_string_literal: true

module Support
  module Schemas
    module Types
      include Dry.Types

      SafeString = Coercible::String
    end
  end
end
