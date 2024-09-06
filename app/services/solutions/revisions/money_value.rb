# frozen_string_literal: true

module Solutions
  module Revisions
    class MoneyValue
      include Support::EnhancedStoreModel

      attribute :cents, :big_integer
      attribute :currency_iso, :string

      def empty?
        cents.blank? || cents == 0
      end

      # @return [String]
      def to_description
        to_money.format
      end

      # @return [::Money]
      def to_money
        ::Money.new(cents, currency_iso)
      end
    end
  end
end
