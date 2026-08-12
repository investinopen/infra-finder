# frozen_string_literal: true

module Events
  # @see Events::FetchRecipients
  class RecipientsFetcher < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      option :record, Types::Any.optional, optional: true

      option :provider, Types::Provider.optional, as: :provided_provider, optional: true
      option :solution, Types::Solution.optional, as: :provided_solution, optional: true
      option :solution_draft, Types::SolutionDraft.optional, as: :provided_solution_draft, optional: true
      option :solution_intake, Types::SolutionIntake.optional, as: :provided_solution_intake, optional: true
      option :user, Types::User.optional, optional: true

      option :options, Events::RecipientsOptions::Type, default: proc { Events::RecipientsOptions.new }
    end

    standard_execution!

    # @return [ActiveRecord::Relation<User>]
    attr_reader :admins

    # @return [Provider, nil]
    attr_reader :provider

    # @return [Solution, nil]
    attr_reader :solution

    # @return [SolutionDraft, nil]
    attr_reader :solution_draft

    # @return [SolutionIntake, nil]
    attr_reader :solution_intake

    # @return [<Notifiable>]
    attr_reader :recipients

    # @return [Dry::Monads::Success<Notifiable>]
    def call
      run_callbacks :execute do
        yield prepare!

        yield collect!
      end

      Success recipients.compact.select(&:notifiable?).uniq
    end

    wrapped_hook! def prepare
      @recipients = []

      @admins = User.subscribed_to_solution_notifications.where.not(id: user&.id).any_admins

      process_inputs!

      super
    end

    wrapped_hook! def collect
      handle_recipient_from!(solution_intake) if options.associated?

      handle_recipient_from!(provider) if options.editors?

      handle_recipient_from!(solution) if options.editors?

      add_recipients_from!(admins) if options.admins?

      super
    end

    private

    # @param [ActiveRecord::Relation, Array] relation
    # @return [void]
    def add_recipients_from!(relation)
      relation.each do |record|
        handle_recipient_from!(record)
      end
    end

    # @param [Notifiable] source
    def handle_recipient_from!(source)
      case source
      in ::Notifiable => notifiable
        @recipients << notifiable if notifiable.notifiable?
      in ::ProviderEditorAssignment | ::SolutionEditorAssignment => assignment
        handle_recipient_from!(assignment.user)
      in ::Provider => provider
        add_recipients_from!(provider.provider_editor_assignments)
      in ::Solution => solution
        add_recipients_from!(solution.solution_editor_assignments)
      in nil
        # intentionally left blank
      end
    end

    # @return [void]
    def process_inputs!
      @provider = @solution = @solution_draft = @solution_intake = nil

      process! record

      @solution ||= provided_solution
      @solution_draft ||= provided_solution_draft
      @solution_intake ||= provided_solution_intake

      @provider ||= solution_intake&.provider || solution&.provider || provided_provider
    end

    def process!(input)
      case input
      in ::Solution
        @solution = input

        process!(input.provider)
      in ::SolutionDraft
        @solution_draft = input

        process!(input.solution)
      in ::SolutionIntake
        @solution_intake = input

        process!(input.solution)
        process!(input.provider)
      in ::Provider
        @provider ||= input
      in nil
        # intentionally left blank
      end
    end
  end
end
