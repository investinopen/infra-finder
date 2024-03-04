# frozen_string_literal: true

module Solutions
  module Implementations
    # A concern for implementations that contain a single link.
    #
    # @api private
    module WithLink
      extend ActiveSupport::Concern

      included do
        link_mode :single

        attribute :link, Solutions::Link.to_type, default: {}

        validates :link, store_model: true
      end
    end
  end
end
