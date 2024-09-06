# frozen_string_literal: true

module Solutions
  module Revisions
    # @see Solutions::Revisions::Initializer
    class Initialize < Support::SimpleServiceOperation
      service_klass Solutions::Revisions::Initializer
    end
  end
end
