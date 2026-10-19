# frozen_string_literal: true

module Uploads
  # Generate an upload token for whoever is filling in a {SolutionIntake}, who may be anonymous.
  #
  # The token names the intake instead of a user, and {Uploads::Authorize} accepts it only while
  # the intake can still be updated.
  class EncodeIntakeToken
    include Dry::Monads[:result]
    include Common::Deps[encode: "tokens.encode"]

    # @param [SolutionIntake] solution_intake
    # @return [Dry::Monads::Success(String)] the upload token
    def call(solution_intake)
      exp = 5.hours.from_now.to_i

      encode.call(iid: solution_intake.id, aud: "upload", exp:)
    end
  end
end
