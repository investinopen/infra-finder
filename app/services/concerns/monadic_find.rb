# frozen_string_literal: true

# Monadic wrappers for looking up records.
module MonadicFind
  extend ActiveSupport::Concern

  # A monadic wrapper around `ApplicationRecord.find`.
  #
  # @param [Class] model_klass
  # @param [<Object>] primary_key
  # @return [Dry::Monads::Success(ApplicationRecord)]
  # @return [Dry::Monads::Failure(:record_not_found, String)]
  def monadic_find(model_klass, *primary_key)
    model = model_klass.find(*primary_key)
  rescue ActiveRecord::RecordNotFound => e
    Dry::Monads::Result::Failure[:record_not_found, e.message]
  else
    Dry::Monads.Success model
  end

  # @param [ApplicationRecord] model
  # @return [Dry::Monads::Success(ApplicationRecord)]
  # @return [Dry::Monads::Failure(:existing_record_not_found, ApplicationRecord)]
  def monadic_refind(model)
    new_instance = model.class.find model.id
  rescue ActiveRecord::RecordNotFound
    Dry::Monads::Result::Failure[:existing_record_not_found, model]
  else
    Dry::Monads.Success(new_instance)
  end

  # A monadic wrapper around `ApplicationRecord.find_by!`.
  #
  # @param [Class] model_class
  # @param [{ Symbol => Object }] conditions
  # @return [Dry::Monads::Success(ApplicationRecord)]
  # @return [Dry::Monads::Failure(:record_not_found, String)]
  def monadic_find_by(model_klass, **conditions)
    model = model_klass.find_by! conditions
  rescue ActiveRecord::RecordNotFound => e
    Dry::Monads::Result::Failure[:record_not_found, e.message]
  else
    Dry::Monads.Success model
  end
end
