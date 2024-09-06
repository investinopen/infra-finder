# frozen_string_literal: true

module Solutions
  module Revisions
    # @see Solutions::Revisions::Creator
    class Create < Support::SimpleServiceOperation
      service_klass Solutions::Revisions::Creator
    end
  end
end
