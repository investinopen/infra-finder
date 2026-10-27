# frozen_string_literal: true

Rails.application.configure do
  queues = [
    "import:1",
    "export:1",
    "maintenance:1",
    "default,attachments,mailers:3",
  ].join(?;)

  config.good_job.preserve_job_records = true
  config.good_job.retry_on_unhandled_error = false
  config.good_job.on_thread_error = ->(exception) { Rollbar.error(exception) }
  config.good_job.execution_mode = :external
  config.good_job.queues = queues
  config.good_job.threads = 5
  config.good_job.poll_interval = 30 # seconds
  config.good_job.shutdown_timeout = 25 # seconds
  config.good_job.enable_cron = true
  config.good_job.cron = {
    check_claim_states: {
      cron: "0,15,30,45 * * * *",
      class: "Solutions::CheckClaimStatesJob",
      description: "Check for changes in solution claiming",
      set: { priority: 400 },
    },
    check_empty_properties_counts: {
      cron: "0 7 * * *",
      class: "Solutions::CheckAllEmptyPropertiesCountsJob",
      description: "Recount empty properties on every solution",
      set: { priority: 500 },
    },
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
    oauth_prune: {
      cron: "45 8 * * *",
      class: "OAuth::PruneJob",
      description: "Prune unusable OAuth codes and tokens",
      set: { priority: 500 },
    },
    session_prune: {
      cron: "30 8 * * *",
      class: "Sessions::PruneJob",
      description: "Prune expired sessions",
      set: { priority: 500 },
    },
    refresh_option_counters: {
      cron: "*/7 * * * *",
      class: "ControlledVocabularies::RefreshCountersJob",
      description: "Refresh counter caches for solution options",
      set: { priority: 900 },
    },
  }

  config.good_job.dashboard_default_locale = :en
  config.good_job.dashboard_live_poll_enabled = Rails.env.local?
end

GoodJob.configure_active_record do
  connects_to database: { writing: :queue, reading: :queue }
end
