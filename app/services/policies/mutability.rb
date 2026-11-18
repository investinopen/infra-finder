# frozen_string_literal: true

module Policies
  # Provides a mechanism for determining if a record is mutable
  # based on state logic defined in the record and tied to the
  # current user.
  module Mutability
    extend ActiveSupport::Concern

    def initialize(...)
      super

      @record_mutable = calculate_record_mutable

      @mutable = calculate_mutable
    end

    private

    # @abstract
    # @return [Boolean]
    def calculate_mutable = record_mutable?

    # @return [Boolean]
    def calculate_record_mutable = record.try(:mutable?) || false

    # @return [void]
    def enforce_mutable!
      deny!("must be mutable") unless mutable?
    end

    # Indicates whether the record is considered mutable given the
    # current state and user context.
    #
    # @return [Boolean]
    attr_reader :mutable

    alias mutable? mutable

    # Indicates whether the record itself is considered mutable,
    # outside of any user or extraneous context.
    #
    # @return [Boolean]
    attr_reader :record_mutable

    alias record_mutable? record_mutable
  end
end
