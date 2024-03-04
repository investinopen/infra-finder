# frozen_string_literal: true

# A concern for models that generate slugs based on a `name` attribute.
module SluggedByName
  extend ActiveSupport::Concern

  included do
    extend FriendlyId

    friendly_id :name, use: %i[history slugged]
  end
end
