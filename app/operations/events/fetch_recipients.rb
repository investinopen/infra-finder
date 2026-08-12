# frozen_string_literal: true

module Events
  # @see Events::RecipientsFetcher
  class FetchRecipients < Support::SimpleServiceOperation
    service_klass Events::RecipientsFetcher
  end
end
