# frozen_string_literal: true

module Comparisons
  # This is distinguished from {Comparisons::Fetch} as it will
  # _not_ create a new record if one does not exist.
  class FindExisting
    include Dry::Monads[:maybe, :result]

    # @param [Rack::Session::SessionId, String, nil] raw_session_id
    # @return [Dry::Monads::Success(Comparison)]
    # @return [Dry::Monads::Failure(:not_found)]
    def call(raw_session_id)
      Comparisons::Types::SessionID.maybe[raw_session_id].bind do |session_id|
        found = Comparison.find_by(session_id:)

        Maybe(found)
      end.to_result.or do
        Failure[:not_found]
      end
    end
  end
end
