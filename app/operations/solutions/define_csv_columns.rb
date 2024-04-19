# frozen_string_literal: true

module Solutions
  # @see Solutions::CSVColumnDefiner
  class DefineCSVColumns < Support::SimpleServiceOperation
    service_klass Solutions::CSVColumnDefiner
  end
end
