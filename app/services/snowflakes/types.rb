# frozen_string_literal: true

module Snowflakes
  module Types
    include Dry.Types
    include Snowflakes::Constants

    extend Support::EnhancedTypes

    DatacenterID = Coercible::Integer.default(0).constrained(gteq: 0, lteq: MAX_DATACENTER_ID)

    Sequence = Coercible::Integer.default(0).constrained(gteq: 0)

    WorkerID = Coercible::Integer.default(0).constrained(gteq: 0, lteq: MAX_WORKER_ID)
  end
end
