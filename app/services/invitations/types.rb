# frozen_string_literal: true

module Invitations
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    Invitation = ModelInstance("Invitation")
  end
end
