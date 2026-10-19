# frozen_string_literal: true

module ImageAttachments
  # An image size definition.
  #
  # @api private
  # @see ImageAttachments.image_size
  class Size < Dry::Struct
    include Dry::Core::Memoizable

    attribute :name, ImageAttachments::Types::Size
    attribute :width, ImageAttachments::Types::Dimension.optional
    attribute :height, ImageAttachments::Types::Dimension.optional

    # @return [(Integer, Integer)]
    # @return [(Integer, nil)]
    # @return [(nil, Integer)]
    memoize def dimensions
      [width, height].freeze
    end

    # @!attribute [r] graphql_description
    # @return [String]
    memoize def graphql_description
      [graphql_prefix, graphql_suffix, ?.].compact.join
    end

    # @!attribute [r] graphql_enum_name
    # @return [String]
    memoize def graphql_enum_name
      name.to_s.upcase
    end

    # @!attribute [r] human_readable_dimensions
    # @return [String, nil]
    memoize def human_readable_dimensions
      # simplecov:disable
      if width.present? && height.present?
        "%dpx wide by %dpx high" % dimensions
      elsif width.present?
        "%dpx wide with no height limit" % width
      elsif height.present?
        "%dpx high with no width limit" % height
      end
      # simplecov:enable
    end

    private

    # @return [String]
    def graphql_prefix
      "A #{name}-sized image"
    end

    # @return [String, nil]
    def graphql_suffix
      # simplecov:disable
      return nil if human_readable_dimensions.blank?
      # simplecov:enable

      ", constrained to #{human_readable_dimensions}"
    end
  end
end
