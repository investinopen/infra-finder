# frozen_string_literal: true

module Admin
  class ExportCSV < Support::SimpleServiceOperation
    service_klass Admin::CSVExporter
  end
end
