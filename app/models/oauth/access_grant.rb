# frozen_string_literal: true

module OAuth
  # A short-lived authorization code, exchanged for the first token of a token session.
  class AccessGrant < ApplicationRecord
    include ::Doorkeeper::Orm::ActiveRecord::Mixins::AccessGrant

    # Doorkeeper copies `custom_access_token_attributes` from the authorize
    # request onto the grant. These are not stored, so a client cannot choose
    # its own token session; {OAuth::AccessToken} starts one instead.
    attribute :session_id, :string
    attribute :session_started_at, :datetime
  end
end
