# frozen_string_literal: true

module Solutions
  module Implementations
    # A concern for implementations that contain multiple links.
    #
    # @api private
    module WithLinks
      extend ActiveSupport::Concern

      included do
        link_mode :many

        attribute :links, Solutions::Link.to_array_type, default: []

        accepts_nested_attributes_for :links

        validates :links, store_model: true, length: { minimum: 1, if: :requires_populated_link? }
        validates :links, length: { maximum: 10 }
      end
    end
  end
end
