# frozen_string_literal: true

# A `Noticed::Event` extension that adds additional functionality.
module NoticedEventExtension
  extend ActiveSupport::Concern

  include NoticedCommonExtension

  included do
    belongs_to :user, optional: true
  end
end
