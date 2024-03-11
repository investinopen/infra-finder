# frozen_string_literal: true

module Comparisons
  # Fetch (find or create) a {Comparison} for the given request parameters.
  #
  # @see Comparisons::Fetcher
  class Fetch < Support::SimpleServiceOperation
    service_klass Comparisons::Fetcher
  end
end
