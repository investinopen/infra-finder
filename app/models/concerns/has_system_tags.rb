# frozen_string_literal: true

# A record that has "system tags", aka tags set by various system subprocesses
# and not directly manageable through the admin interface.
module HasSystemTags
  extend ActiveSupport::Concern

  included do
    acts_as_taggable_on :system_tags

    scope :with_system_tags, ->(*tags) { tagged_with(*tags, on: :system_tags) }
  end
end
