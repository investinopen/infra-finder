# frozen_string_literal: true

module Processing
  class PromoteAttachmentJob < ApplicationJob
    queue_as :attachments

    discard_on ActiveRecord::RecordNotFound

    discard_on Shrine::AttachmentChanged

    retry_on ActiveRecord::StatementInvalid, wait: :polynomially_longer, attempts: 10

    queue_with_priority 200

    # @return [void]
    def perform(attacher_class, record_class, record_id, name, file_data)
      attacher_class = Object.const_get(attacher_class)
      record = Object.const_get(record_class).find(record_id)

      attacher = attacher_class.retrieve(model: record, name:, file: file_data)

      attacher.file.open do
        attacher.refresh_metadata! if attacher.respond_to?(:refresh_metadata!)
        attacher.create_derivatives(attacher.file.tempfile) if attacher.respond_to?(:create_derivatives)
        record.on_promote!(name) if record.respond_to?(:on_promote!)
      end

      attacher.atomic_promote
    end
  end
end
