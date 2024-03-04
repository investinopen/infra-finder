# frozen_string_literal: true

# Monadic helpers for persisting records.
module MonadicPersistence
  extend ActiveSupport::Concern

  include MonadicFind

  # Attempt to destroy a record
  #
  # @param [ApplicationRecord] model
  # @return [Dry::Monads::Success(void)]
  # @return [Dry::Monads::Failure(:indestructible, ApplicationRecord)]
  def monadic_destroy(model)
    model.destroy

    if model.destroyed?
      Dry::Monads.Success()
    else
      Dry::Monads::Result::Failure[:indestructible, model]
    end
  end

  # Attempt to save a record.
  #
  # @param [ApplicationRecord] model
  # @return [Dry::Monads::Success(ApplicationRecord)]
  # @return [Dry::Monads::Failure(:invalid, ApplicationRecord, <String>)]
  def monadic_save(model)
    if model.save
      Dry::Monads.Success(model)
    else
      Dry::Monads::Result::Failure[:invalid, model, model.errors.full_messages.to_a]
    end
  end

  # @param [Class#upsert] klass
  # @param [Hash] attributes
  # @param [<Symbol>] unique_by
  # @return [Dry::Monads::Result]
  def monadic_upsert(klass, attributes, unique_by:)
    klass.upsert attributes, unique_by:, returning: :id

    tuple = Array(unique_by).index_with { |k| attributes.fetch(k) }.symbolize_keys

    monadic_find_by(klass, **tuple)
  end
end
