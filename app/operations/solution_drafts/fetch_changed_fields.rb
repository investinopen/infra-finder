# frozen_string_literal: true

module SolutionDrafts
  # Fetch an array of {SolutionDrafts::ChangedField}s.
  #
  # @see SolutionDrafts::ChangedFieldsFetcher
  class FetchChangedFields < Support::SimpleServiceOperation
    service_klass SolutionDrafts::ChangedFieldsFetcher
  end
end
