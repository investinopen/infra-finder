# frozen_string_literal: true

module SolutionIntakes
  # @see SolutionIntakes::Approve
  # @see SolutionIntakes::Approver
  # @see SolutionIntakesMailer#approved
  class ApprovedNotifier < ApplicationNotifier
    fetches_recipients! associated: true

    deliver_by :email do |config|
      config.mailer = "SolutionIntakesMailer"
      config.method = :approved
    end

    required_param :invited
    required_param :solution
    required_param :solution_intake
    required_param :solution_name
  end
end
