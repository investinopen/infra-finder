# frozen_string_literal: true

module MonadicTransitions
  extend ActiveSupport::Concern

  # @param [UsesStatesman] model
  # @param [Symbol] to_state
  # @return [Dry::Monads::Success(void)]
  # @return [Dry::Monads::Failure(:unavailable_transition, UsesStatesman, Symbol)]
  def monadic_transition_check(model, to_state)
    if model.can_transition_to?(to_state)
      Dry::Monads.Success()
    else
      Dry::Monads::Failure[:unavailable_transition, model, to_state]
    end
  end

  # @param [UsesStatesman] model
  # @param [Symbol] to_state
  # @param [{ Symbol => Object }] metadata
  # @return [Dry::Monads::Success(UsesStatesman)]
  # @return [Dry::Monads::Failure(:invalid_transition, UsesStatesman, Symbol, { Symbol => Object })]
  def monadic_transition(model, to_state, **metadata)
    if model.transition_to(to_state, **metadata)
      Dry::Monads.Success(model)
    else
      Dry::Monads::Failure[:invalid_transition, model, to_state, metadata]
    end
  end
end
