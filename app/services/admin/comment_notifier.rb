# frozen_string_literal: true

module Admin
  class CommentNotifier < Support::HookBased::Actor
    include AfterCommitEverywhere
    include Dry::Initializer[undefined: false].define -> do
      param :comment, Types::Comment

      option :verb, Types::MutationVerb
    end

    standard_execution!

    delegate :author, :resource, to: :comment

    # @return [Hash]
    attr_reader :base_params

    # @return [<User>]
    attr_reader :recipients

    # @return [Dry::Monads::Success(void)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield on_verb!
      end

      Success(nil)
    end

    wrapped_hook! def prepare
      @recipients = gather_recipients

      @base_params = {
        comment:,
      }

      super
    end

    wrapped_hook! def on_verb
      case verb
      in :create
        yield on_create!
      in :update
        yield on_update!
      in :destroy
        yield on_destroy!
      else
        # :nocov:
        return Failure[:invalid_verb, verb]
        # :nocov:
      end

      super
    end

    wrapped_hook! def on_create
      each_recipient_params do |params|
        CommentNotificationsMailer.with(params).created.deliver_later
      end

      super
    end

    wrapped_hook! :on_update

    wrapped_hook! :on_destroy

    private

    def each_recipient
      recipients.find_each do |recipient|
        yield recipient
      end
    end

    def each_recipient_params
      each_recipient do |recipient|
        params = base_params.merge(recipient:)

        after_commit do
          yield params
        end
      end
    end

    # @return [ActiveRecord::RecordNotFound]
    def gather_recipients
      case resource
      when Solution, SolutionDraft
        User
          .subscribed_to_comment_notifications.where.not(id: author.id)
          .with_access_to(resource)
      else
        # :nocov:
        User.none
      end
    end
  end
end
