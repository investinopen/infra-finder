# frozen_string_literal: true

module SolutionProperties
  module HasLogo
    extend ActiveSupport::Concern

    included do
      include ImageUploader::Attachment.new(:logo)

      scope :with_logo_in_storage, ->(storage) { where(arel_json_get_as_text(:logo_data, :storage).eq(storage)) }
      scope :with_cached_logo, -> { with_logo_in_storage(:cache) }
      scope :with_stored_logo, -> { with_logo_in_storage(:store) }
      scope :sans_logo, -> { where(logo_data: nil) }
    end
  end
end
