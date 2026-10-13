# frozen_string_literal: true

module VOGMutations
  # A per-instance authorizer for a mutation.
  # It handles all the action policy memoization without polluting the other VOGMutation classes.
  class Authorizer
    include ActionPolicy::Behaviour
    include ActionPolicy::Behaviours::ThreadMemoized
    include ActionPolicy::Behaviours::Memoized

    include Dry::Initializer[undefined: false].define -> do
      option :current_user, ::Users::Types::Current, default: ::Users::Types::DEFAULT_FROM_REQUEST
    end

    authorize :user, through: :current_user
  end
end
