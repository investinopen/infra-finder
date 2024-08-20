# frozen_string_literal: true

module Admin
  # A class for interacting with certain ActiveAdmin-related classes
  # when we need to simulate a view context outside the normal request cycle.
  #
  # @api private
  class FakeViewContext
    include MethodOrProcHelper
  end
end
