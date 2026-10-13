# frozen_string_literal: true

module VOGMutations
  # Authorization logic for {VOGMutations::Base} mutations.
  module Authorization
    extend ActiveSupport::Concern

    include VOGMutations::ReadsCurrentMutation

    # @see https://actionpolicy.evilmartians.io/#/behaviour
    # @see VOGMutations::FlowControl#throw_unauthorized
    # @return [void]
    def authorize(record, to, **options)
      authorizer.authorize!(record, **options, to:)
    rescue ActionPolicy::Unauthorized
      throw_unauthorized
    end

    module ClassMethods
      # Declare that the mutation requires the permission described by `with`
      # on a model instance stored in {#args} with the key `arg_key`.
      #
      # This can be called multiple times if a mutation requires multiple auth checks.
      # All must pass for the mutation to be authorized.
      #
      # @see VOGMutations::Types::AuthPredicate
      # @see https://actionpolicy.evilmartians.io/#/
      # @example Require update permissions for an account
      #   authorizes! :account, with: :update?
      # @param [Symbol] arg_key the name of the argument holding the record to authorize
      # @param [Symbol] with the verb to authorize with, must end with a `"?"` (@see VOGMutations::Types::AuthPredicate)
      # @return [void]
      def authorizes!(arg_key, with:)
        key = VOGMutations::Types::ArgKey[arg_key]

        predicate = VOGMutations::Types::AuthPredicate[with]

        verb = predicate.to_s.chomp(??)

        if arg_key == :current_user
          class_eval <<~RUBY, __FILE__, __LINE__ + 1
            before_authorization def authorize_current_user_to_#{verb}!
              authorize current_user, #{predicate.inspect}
            end
          RUBY
          return
        end

        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        before_authorization def authorize_#{arg_key}_to_#{verb}!
          model = args.fetch(#{key.inspect})

          authorize model, #{predicate.inspect}
        end
        RUBY
      end
    end
  end
end
