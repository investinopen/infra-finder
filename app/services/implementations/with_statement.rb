# frozen_string_literal: true

module Implementations
  # A concern for implementations that include a textual statement
  # to be associated with them.
  #
  # @api private
  module WithStatement
    extend ActiveSupport::Concern

    included do
      extend Dry::Core::ClassAttributes

      defines :requires_statement, type: Implementations::Types::Bool

      requires_statement false

      attribute :statement, :string

      validates :statement, presence: { if: :requires_statement? }
    end

    def requires_statement? = self.class.requires_statement
  end
end
