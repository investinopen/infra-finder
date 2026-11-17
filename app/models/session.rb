# frozen_string_literal: true

# Your session-of-record model — deliberately a 3-line shell: ALL the gem's
# behavior (device names, revocation, scopes, the trail) lives in the
# Sessions::Model concern, so this file never goes stale across gem updates.
# It's also exactly the model `rails generate authentication` would create,
# which keeps a future move to Rails' built-in auth a no-op for this table.
class Session < ApplicationRecord
  include Sessions::Model
end
