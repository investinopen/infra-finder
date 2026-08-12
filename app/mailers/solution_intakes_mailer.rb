# frozen_string_literal: true

class SolutionIntakesMailer < ApplicationMailer
  before_action :extract_common_params!

  default subject: -> { t(".subject", solution_name:) },
    to: -> { recipient_address }

  # @return [Boolean]
  attr_reader :invited

  alias invited? invited

  helper_method :invited?

  # @return [Notifiable]
  attr_reader :recipient

  # @return [String]
  attr_reader :recipient_name

  helper_method :recipient_name

  # @return [Mail::Address]
  attr_reader :recipient_address

  # @return [Solution, nil]
  attr_reader :solution

  helper_method :solution

  # @return [SolutionIntake]
  attr_reader :solution_intake

  helper_method :solution_intake

  # @return [String]
  attr_reader :solution_name

  helper_method :solution_name

  # @see SolutionIntakes::ApprovedNotifier
  def approved
    mail
  end

  # @see SolutionIntakes::SubmittedNotifier
  def submitted
    mail
  end

  private

  # @return [void]
  def extract_common_params!
    @invited = params.fetch(:invited, false)

    @recipient = params.fetch(:recipient)
    @solution_intake = params.fetch(:solution_intake)
    @solution = params.fetch(:solution, nil)

    @solution_name = params.fetch(:solution_name) do
      solution&.name || solution_intake.name
    end

    @recipient_address = recipient.to_mail_address

    @recipient_name = recipient.to_email_contact.display_name
  end
end
