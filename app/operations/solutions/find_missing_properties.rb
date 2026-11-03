# frozen_string_literal: true

module Solutions
  # @see Solutions::MissingPropertiesFinder
  class FindMissingProperties < Support::SimpleServiceOperation
    service_klass Solutions::MissingPropertiesFinder
  end
end
