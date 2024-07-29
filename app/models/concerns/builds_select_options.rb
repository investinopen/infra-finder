# frozen_string_literal: true

# A concern for models that build select options.
module BuildsSelectOptions
  extend ActiveSupport::Concern

  module ClassMethods
    # @abstract
    # @return [Arel::Expression, nil]
    def select_option_props_expression; end

    # @api private
    # @abstract
    # @return [ActiveRecord::Relation<BuildsSelectOptions>]
    def order_for_select_options
      lazily_order(:name)
    end

    # @return [<(String, String)>]
    def to_select_options
      projections = [
        :name,
        :id,
        select_option_props_expression
      ].compact

      order_for_select_options.pluck(*projections)
    end
  end
end
