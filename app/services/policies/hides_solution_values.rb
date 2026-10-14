# frozen_string_literal: true

module Policies
  # Rules for the solution property values the public site does not show.
  #
  # @see SolutionProperty#hidden_rule
  module HidesSolutionValues
    # Whether the user may see values marked `hidden: true`.
    #
    # @return [Boolean]
    def show_hidden?
      show?
    end

    # Whether the user may see financial numbers, which are public once
    # the record approves publishing them.
    #
    # @return [Boolean]
    def show_financials?
      record.financial_numbers_approved_to_publish? || show_hidden?
    end
  end
end
