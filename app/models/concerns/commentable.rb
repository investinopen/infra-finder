# frozen_string_literal: true

# A record that admins and editors can leave {Comment}s on.
module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :resource, inverse_of: :resource, dependent: :delete_all
  end
end
