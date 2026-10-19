# frozen_string_literal: true

module Processing
  # Rebuilds a stored attachment's derivatives, replacing the old ones, e.g. after
  # {ImageAttachments::Constants} changes.
  class RegenerateDerivativesJob < ApplicationJob
    queue_as :attachments

    discard_on ActiveRecord::RecordNotFound

    discard_on Vips::Error

    queue_with_priority 300

    # @param [ApplicationRecord] record
    # @param [String] name the attachment name
    # @return [void]
    def perform(record, name)
      attacher = record.public_send(:"#{name}_attacher")

      return unless attacher.stored?

      old_derivatives = attacher.derivatives

      attacher.create_derivatives

      begin
        attacher.atomic_persist
      rescue Shrine::AttachmentChanged, ActiveRecord::RecordNotFound
        attacher.delete_derivatives
      else
        attacher.delete_derivatives(old_derivatives)
      end
    end
  end
end
