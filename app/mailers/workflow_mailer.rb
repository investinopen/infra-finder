# frozen_string_literal: true

class WorkflowMailer < ApplicationMailer
  before_action :extract_common_params!

  default subject: -> { t(".subject", solution_name:) },
    to: -> { recipient_email }

  # @return [User]
  attr_reader :initiator

  # @return [User]
  attr_reader :recipient

  # @return [Solution]
  attr_reader :solution

  # @return [Symbol]
  attr_reader :workflow_action

  delegate :name, to: :initiator, prefix: true
  delegate :email, :name, to: :recipient, prefix: true
  delegate :name, to: :solution, prefix: true

  helper_method :initiator
  helper_method :initiator_name
  helper_method :recipient
  helper_method :recipient_name
  helper_method :solution
  helper_method :solution_name
  helper_method :workflow_action

  def request_review
    @workflow_action = __method__

    mail
  end

  def request_revision
    @workflow_action = __method__

    mail
  end

  def approve
    @workflow_action = __method__

    mail
  end

  def reject
    @workflow_action = __method__

    mail
  end

  private

  def extract_common_params!
    @draft = params.fetch(:draft)
    @solution = draft.solution || params.fetch(:solution)
    @recipient = params.fetch(:recipient)
    @initiator = params.fetch(:initiator)
    @memo = params[:memo].presence
  end
end
