# frozen_string_literal: true

module Users
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    Kind = Coercible::Symbol.default(:anonymous).enum(:super_admin, :admin, :editor, :user, :anonymous).fallback(:anonymous)
  end
end
