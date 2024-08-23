# frozen_string_literal: true

module Invitations
  # @see Invitations::Notifier
  class Notify < Support::SimpleServiceOperation
    service_klass Invitations::Notifier
  end
end
