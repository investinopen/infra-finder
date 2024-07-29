# frozen_string_literal: true

module ControlledVocabularies
  class FetchOptions < Support::SimpleServiceOperation
    service_klass ControlledVocabularies::OptionsFetcher
  end
end
