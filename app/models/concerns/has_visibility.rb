# frozen_string_literal: true

# A concern for models that have some kind of visibility.
module HasVisibility
  extend ActiveSupport::Concern

  included do
    pg_enum! :visibility, as: :visibility, allow_blank: false, default: "hidden"
  end
end
