# frozen_string_literal: true

module Structured
  # @abstract
  class Model
    include Support::EnhancedStoreModel
    include Structured::CSVConversion

    strip_attributes

    attr_accessor :_destroy
  end
end
