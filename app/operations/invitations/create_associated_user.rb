# frozen_string_literal: true

module Invitations
  # @see Invitations::UserCreator
  class CreateAssociatedUser < Support::SimpleServiceOperation
    service_klass Invitations::UserCreator
  end
end
