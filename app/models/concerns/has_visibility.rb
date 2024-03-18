# frozen_string_literal: true

# A concern for models that have some kind of visibility.
module HasVisibility
  extend ActiveSupport::Concern

  include ExposesRansackable

  included do
    pg_enum! :visibility, as: :visibility, allow_blank: false, default: "hidden"

    expose_ransackable_attributes! :visibility, on: :admin
    expose_ransackable_scopes! :visible, :hidden, on: :admin
  end
end
