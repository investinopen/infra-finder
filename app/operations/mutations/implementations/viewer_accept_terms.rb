# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::ViewerAcceptTerms
    class ViewerAcceptTerms < VOGMutations::Implementation
      use_contract! :viewer_accept_terms

      authorizes! :current_user, with: :manage_own_session?

      # @param [Boolean] accept_terms_and_conditions
      # @return [void]
      def call(accept_terms_and_conditions:)
        user = current_user

        user.accept_terms_and_conditions = accept_terms_and_conditions unless user.accepted_terms?

        invalid_model!(user) unless user.save(context: :accepting_terms)

        attach! :user, user
      end
    end
  end
end
