# frozen_string_literal: true

module Implementations
  # A concern for implementations that contain a single link.
  #
  # @api private
  module WithLink
    extend ActiveSupport::Concern

    included do
      link_mode :single

      attribute :link, Implementations::Link.to_type, default: {}

      accepts_nested_attributes_for :link

      validates :link, store_model: true
    end

    module ClassMethods
      def build_dry_schema
        super.tap do |schema|
          schema[:link?] = Implementations::Types::LinkSchema.optional
        end
      end
    end
  end
end
