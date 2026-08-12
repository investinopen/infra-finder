# frozen_string_literal: true

# @abstract
class ApplicationNotifier < Noticed::Event
  include ::NoticedCommonExtension
  include ::Events::FetchesRecipients
  include ::Events::Named

  belongs_to :provider, optional: true
  belongs_to :solution, optional: true
  belongs_to :solution_draft, optional: true
  belongs_to :solution_intake, optional: true
  belongs_to :user, optional: true

  before_validation :derive_data!

  # @param [Notifiable] recipient
  # @return [Hash]
  def recipient_attributes_for(recipient)
    email_contact = Emails::EmailContact.from(recipient)
    email_deliverable = email_contact.deliverable?

    attrs = super.merge(
      email_contact:,
      email_deliverable:,
    )

    details = recipient_details_for(recipient, **attrs)

    attrs[:details] = details

    return attrs
  end

  def recipient_details_for(recipient, **attrs)
    {}
  end

  class << self
    # @param [Hash] params
    # @option params [Solution, nil] :solution
    # @option params [SolutionDraft, nil] :solution_draft
    # @option params [SolutionIntake, nil] :solution_intake
    # @return [ApplicationNotifier]
    def with(**params)
      super(normalize_params_for(**params))
    end

    # A helper that will make sure `:record` is appropriately set based on the params provided.
    #
    # @api private
    # @param [Hash] params
    # @option params [Provider, nil] :provider
    # @option params [Solution, nil] :solution
    # @option params [SolutionDraft, nil] :solution_draft
    # @option params [SolutionIntake, nil] :solution_intake
    # @return [Hash]
    def normalize_params_for(**params)
      InfraFinder::Container["events.normalize_params"].(params).value!
    end
  end
end
