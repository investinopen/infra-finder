# frozen_string_literal: true

module VOG
  module LazyOrdering
    extend ActiveSupport::Concern

    module ClassMethods
      # @param [Symbol] column
      # @return [ActiveRecord::Relation]
      def lazily_order(column, raw_direction = :asc)
        base = lazy_order_scope_for column

        expr = lazy_order_expr_for(column, raw_direction:)

        base.order(expr)
      end

      def lazy_order_column_for(column)
        method_name = :"#{column}_order_column"

        if respond_to?(method_name)
          public_send(method_name)
        else
          column
        end.then { |expr| lazy_order_column_validate(expr) }
      end

      def lazy_order_column_validate(expr)
        case expr
        in Array
          expr.map { lazy_order_column_validate(_1) }
        else
          arel_attrify(expr)
        end
      end

      def lazy_order_expr_for(column, raw_direction: "asc")
        direction = Support::GlobalTypes::SimpleSortDirection[raw_direction]

        method_name = :"#{column}_order_expression"

        if respond_to?(method_name)
          public_send(method_name, direction:)
        else
          attr = lazy_order_column_for column

          case attr
          in Array
            attr.map { |a| a.send(direction) }
          else
            attr.send(direction)
          end
        end
      end

      # @param [Symbol] column
      # @return [ActiveRecord::Relation]
      def lazy_order_scope_for(column)
        scope_name = :"prepare_order_for_#{column}"

        if respond_to?(scope_name)
          all.public_send(scope_name)
        else
          all
        end
      end
    end
  end
end
