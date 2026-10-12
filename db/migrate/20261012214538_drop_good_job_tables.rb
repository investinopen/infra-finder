# frozen_string_literal: true

# GoodJob now lives in the queue database. Its jobs are disposable, so the old tables are dropped, not copied.
class DropGoodJobTables < ActiveRecord::Migration[8.1]
  TABLES = %i[
    good_job_batches
    good_job_concurrency_claims
    good_job_executions
    good_job_processes
    good_job_settings
    good_jobs
  ].freeze

  def up
    TABLES.each do |table|
      drop_table table, if_exists: true
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
