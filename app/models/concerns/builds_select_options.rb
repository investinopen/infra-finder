# frozen_string_literal: true

# A concern for models that build select options.
module BuildsSelectOptions
  extend ActiveSupport::Concern

  module ClassMethods
    # @api private
    # @abstract
    # @return [ActiveRecord::Relation<BuildsSelectOptions>]
    def order_for_select_options
      lazily_order(:name)
    end

    # @return [<(String, String)>]
    def to_select_options
      order_for_select_options.pluck(:name, :id)
    end
  end
end
