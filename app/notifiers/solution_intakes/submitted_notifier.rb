# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntakes::Submit
  # @see SolutionIntakes::Submitter
  # @see SolutionIntakesMailer#submitted
  class SubmittedNotifier < ApplicationNotifier
    fetches_recipients! admins: true

    deliver_by :email do |config|
      config.mailer = "SolutionIntakesMailer"
      config.method = :submitted
    end

    required_param :solution_intake
    required_param :solution_name
  end
end
