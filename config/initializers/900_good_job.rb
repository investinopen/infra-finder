# frozen_string_literal: true

Rails.application.configure do
  # Future-proofing
  config.good_job.smaller_number_is_higher_priority = true

  queues = [
    "export:1",
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
  config.good_job.enable_cron = false
  config.good_job.cron = {
    # section_content_prune_orphaned_tei: {
    # cron: "0,15,30,45 * * * *",
    # class: "SectionContents::PruneOrphanedTEIJob",
    # description: "Prune orphaned TEI roots",
    # set: { priority: 500 },
    # },
    # section_content_prune_orphaned_legacy_html: {
    # cron: "0,15,30,45 * * * *",
    # class: "SectionContents::PruneOrphanedLegacyHTMLJob",
    # description: "Prune orphaned Legacy HTML roots",
    # set: { priority: 500 },
    # },
  }

  config.good_job.dashboard_default_locale = :en
end

GoodJob::Engine.middleware.use(Rack::Auth::Basic) do |username, password|
  SecurityConfig.validate_basic_auth?(username, password)
end unless Rails.env.development?

GoodJob::Engine.middleware.use Rack::MethodOverride
GoodJob::Engine.middleware.use ActionDispatch::Flash
GoodJob::Engine.middleware.use ActionDispatch::Cookies
GoodJob::Engine.middleware.use ActionDispatch::Session::CookieStore
