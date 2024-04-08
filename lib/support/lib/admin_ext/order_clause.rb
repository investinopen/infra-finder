# frozen_string_literal: true

module Support
  module AdminExt
    # This will use our {LazyOrdering} concern when sorting in ActiveAdmin.
    class OrderClause < ::ActiveAdmin::OrderClause
      delegate :resource_class, to: :active_admin_config

      # @return [String]
      def raw_direction
        @raw_direction ||= @order.downcase
      end

      # @return [String]
      def to_sql
        # :nocov:
        return super unless resource_class < LazyOrdering && @column !~ /\./ && @op.blank?
        # :nocov:

        resource_class.lazy_order_expr_for(@column, raw_direction:).to_sql
      end
    end
  end
end
