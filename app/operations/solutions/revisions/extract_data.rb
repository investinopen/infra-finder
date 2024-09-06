# frozen_string_literal: true

module Solutions
  module Revisions
    # @see Solutions::Revisions::DataExtractor
    class ExtractData < Support::SimpleServiceOperation
      service_klass Solutions::Revisions::DataExtractor
    end
  end
end
