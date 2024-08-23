# frozen_string_literal: true

module Invitations
  # @see Invitations::Finalizer
  class Finalize < Support::SimpleServiceOperation
    service_klass Invitations::Finalizer
  end
end
