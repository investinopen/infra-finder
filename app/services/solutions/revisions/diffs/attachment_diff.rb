# frozen_string_literal: true

module Solutions
  module Revisions
    module Diffs
      class AttachmentDiff < BaseDiff
        diffs! ::Solutions::Revisions::Attachment.to_type

        # @param [Solutions::Revisions::Attachment]
        def describe(value)
          value.to_description
        end

        def has_no_new_value?
          new_value.blank? || new_value.try(:empty_attachment?)
        end
      end
    end
  end
end
