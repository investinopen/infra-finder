# frozen_string_literal: true

module Support
  module GraphQLAPI
    module ImageAttachmentSupport
      extend ActiveSupport::Concern

      # @param [String] graphql_name
      # @return [::ImageAttachments::ImageWrapper]
      def resolve_image_attachment(graphql_name:)
        attacher, purpose = resolve_image_attacher_and_purpose_for(graphql_name: graphql_name)

        ::ImageAttachments::ImageWrapper.new(attacher, purpose:)
      end

      # @api private
      # @param [String] graphql_name
      # @return [(Shrine::Attacher, String)]
      def resolve_image_attacher_and_purpose_for(graphql_name:)
        purpose = graphql_name.underscore

        attacher = object.public_send :"#{purpose}_attacher"

        [attacher, purpose]
      end

      module ClassMethods
        def image_attachment_field(name, description: nil, scope: :image, &)
          field_type, resolver_method = image_resolver_values_for(scope)

          field_options = {
            null: false,
            description:,
            resolver_method:,
            extras: %i[graphql_name]
          }.compact

          field(name, field_type, **field_options, &)

          metadata_name = :"#{name}_metadata"

          field metadata_name, ::Types::ImageMetadataType, null: true do
            description "Configurable metadata for the #{name} attachment"
          end
        end

        # @param [Symbol] scope
        # @return [(Class, Symbol)]
        def image_resolver_values_for(scope)
          [::Types::ImageAttachmentType, :resolve_image_attachment]
        end
      end
    end
  end
end
