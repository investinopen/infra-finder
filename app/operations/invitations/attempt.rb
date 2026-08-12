# frozen_string_literal: true

module Invitations
  # @see Invitations::Attempter
  class Attempt < Support::SimpleServiceOperation
    service_klass Invitations::Attempter
  end
end
