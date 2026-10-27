# frozen_string_literal: true

RSpec.describe ApplicationJob, type: :job do
  let(:job_klass) do
    Class.new(described_class) do
      include Dry::Effects::Handler.Reader(:application_job_spec)

      class << self
        attr_accessor :observed

        def name = "ApplicationJobSpecJob"
      end

      def perform
        ApplicationRecord.transaction do
          outer = [Fiber.current, ApplicationRecord.connection]

          inner = with_application_job_spec(true) { [Fiber.current, ApplicationRecord.connection] }

          self.class.observed = { outer:, inner:, }
        end
      end
    end
  end

  # The rspec extension for dry-effects wraps every example in a handler, so the
  # job has to run in a fresh fiber to start from an empty effect stack.
  def perform_in_fresh_fiber
    Fiber.new do
      job_klass.perform_now
    ensure
      ApplicationRecord.connection_pool.release_connection
    end.resume
  end

  it "runs nested effect handlers in the job's fiber and connection" do
    perform_in_fresh_fiber

    expect(job_klass.observed[:inner]).to eq job_klass.observed[:outer]
  end
end
