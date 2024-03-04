# frozen_string_literal: true

module Solutions
  module Implementations
    # A concern for implementations that include a textual statement
    # to be associated with them.
    #
    # @api private
    module WithStatement
      extend ActiveSupport::Concern

      included do
        attribute :statement, :string

        validates :statement, presence: { if: :requires_statement? }
      end

      def requires_statement?
        available?
      end
    end
  end
end
