# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  include ::Support::CallsCommonOperation

  include Dry::Effects::Handler.Reader(:application_job, as: :with_effects_frame)

  retry_on StandardError, wait: :polynomially_longer, attempts: 10

  retry_on ActiveRecord::StatementInvalid, wait: :polynomially_longer, attempts: 10

  # Automatically retry jobs that encountered a deadlock
  # with less attempts than default.
  retry_on ActiveRecord::Deadlocked, wait: :polynomially_longer, attempts: 5

  # Most jobs are safe to ignore if the underlying records are no longer available
  discard_on ActiveJob::DeserializationError

  # Discard jobs where the operation itself fails. There are
  # no known cases where we would want to retry these.
  discard_on Dry::Monads::UnwrapError

  # If we raise this, we want to halt the job entirely and mark it as discarded.
  discard_on Utility::HaltedJobError

  after_discard do |job, error|
    meta = {
      queue: job.queue_name,
      job_id: job.job_id,
      arguments: job.arguments,
      job_class: job.class.name,
    }

    case error
    when ActiveJob::DeserializationError
      # simplecov:disable
      # intentionally left blank, we don't care about these
      # simplecov:enable
    when Utility::HaltedJobError
      Rollbar.info(error, **meta)
    else
      Rollbar.error(error, queue: job.queue_name, job_id: job.job_id, arguments: job.arguments, job_class: job.class.name)
    end
  end

  around_perform :keep_effects_on_job_fiber!
  around_perform :watch_for_fatal_errors!

  private

  # dry-effects runs the outermost handler in a fiber of its own, and with fiber
  # isolation each fiber leases its own database connection. Opening a handler
  # first keeps nested handlers (every hook-based actor, for one) in this fiber and
  # on the job's connection. Otherwise their writes escape the job's transaction,
  # or block forever on rows it has locked.
  #
  # @see VOGMutations::Executor#execute!
  # @return [void]
  def keep_effects_on_job_fiber!(&)
    with_effects_frame(self, &)
  end

  # @see Utility::HaltedJobError
  # @return [void]
  def watch_for_fatal_errors!
    yield
  rescue Dry::Monads::UnwrapError => e
    case e.receiver
    in Dry::Monads::Failure[:fatal_error, String => reason]
      raise Utility::HaltedJobError, "Fatal Error: #{reason}"
    else
      raise e
    end
  end
end
