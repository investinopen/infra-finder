# frozen_string_literal: true

module SolutionProperties
  module Accessors
    class Attachment < SolutionProperties::Accessors::AbstractAccessor
      property_kind! :attachment

      def apply_value_to(attr, value)
        return if value.blank?

        attacher = instance.__send__(:"#{attr}_attacher")

        attacher.assign_remote_url value, metadata: { "original_import_url" => value }
      end

      def to_csv
        attachment = instance.__send__(attribute_name)

        attacher = instance.__send__(:"#{attribute_name}_attacher")

        return if attachment.blank? || !attacher.try(:stored?)

        # :nocov:
        if Rails.env.development? && attachment.original_import_url.present?
          return attachment.original_import_url
        end
        # :nocov:

        attachment.url
      end
    end
  end
end
