# frozen_string_literal: true

Rails.application.configure do
  # Future-proofing
  config.good_job.smaller_number_is_higher_priority = true

  queues = [
    "import:1",
    "export:1",
    "maintenance:1",
    "attachments,mailers:3",
  ].join(?;)

  config.good_job.preserve_job_records = true
  config.good_job.retry_on_unhandled_error = true
  config.good_job.on_thread_error = ->(exception) { Rollbar.error(exception) }
  config.good_job.execution_mode = :external
  config.good_job.queues = queues
  config.good_job.max_threads = 5
  config.good_job.poll_interval = 30 # seconds
  config.good_job.shutdown_timeout = 25 # seconds
  config.good_job.enable_cron = true
  config.good_job.cron = {
    comparison_prune: {
      cron: "0 8 * * *",
      class: "Comparisons::PruneJob",
      description: "Prune stale comparisons",
      set: { priority: 500 },
    },
    comparison_share_prune: {
      cron: "15 * * * *",
      class: "ComparisonShares::PruneJob",
      description: "Prune stale comparison shares",
      set: { priority: 300 },
    },
    refresh_option_counters: {
      cron: "*/7 * * * *",
      class: "SolutionOptions::RefreshCountersJob",
      description: "Refresh counter caches for solution options",
      set: { priority: 900 },
    },
  }

  config.good_job.dashboard_default_locale = :en
  config.good_job.dashboard_live_poll_enabled = Rails.env.local?
end
