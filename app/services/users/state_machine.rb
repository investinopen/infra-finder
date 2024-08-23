# frozen_string_literal: true

module Users
  class StateMachine
    include Statesman::Machine

    state :pending, initial: true
    state :accepted_terms

    transition from: :pending, to: :accepted_terms
    transition from: :accepted_terms, to: :pending

    after_transition(to: :accepted_terms) do |user, _|
      user.touch(:accepted_terms_at)
    end

    after_transition(from: :accepted_terms) do |user, _|
      user.update_columns(accepted_terms_at: nil)
    end
  end
end
