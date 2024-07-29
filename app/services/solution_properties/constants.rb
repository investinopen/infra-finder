# frozen_string_literal: true

module SolutionProperties
  module Constants
    extend ActiveSupport::Concern

    DEFAULT_INPUT_PATH = Rails.root.join("vendor", "properties.csv")
    DEFAULT_OUTPUT_PATH = Rails.root.join("lib", "frozen_record", "solution_properties.yml")
  end
end
