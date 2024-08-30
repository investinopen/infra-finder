# frozen_string_literal: true

module SubscriptionOptions
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    All = Coercible::Symbol.constrained(eql: :all)

    Column = Coercible::Symbol.constrained(filled: true, format: /\A[a-z]\w+[a-z]\z/, not_eql: :all)

    Kind = ApplicationRecord.dry_pg_enum(:subscription_kind, symbolize: true)

    InstanceMode = Symbol.enum(:all, :option)

    Selection = Column | All

    Token = Coercible::String
  end
end
