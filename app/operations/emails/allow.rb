# frozen_string_literal: true

module Emails
  # @see Emails::Allower
  class Allow < Support::SimpleServiceOperation
    service_klass Emails::Allower
  end
end
