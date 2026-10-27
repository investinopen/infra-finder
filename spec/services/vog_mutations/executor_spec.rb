# frozen_string_literal: true

RSpec.describe VOGMutations::Executor do
  let(:implementation_klass) do
    Class.new(VOGMutations::Implementation) do
      include Dry::Effects::Handler.Reader(:executor_spec)

      attr_reader :observed

      def call(**)
        outer = [Fiber.current, ApplicationRecord.connection]

        inner = with_executor_spec(true) { [Fiber.current, ApplicationRecord.connection] }

        @observed = { outer:, inner:, }
      end
    end
  end

  let(:operation) { implementation_klass.new }

  let(:executor) { described_class.new(operation, operation_name: "executor_spec") }

  # The rspec extension for dry-effects wraps every example in a handler, so the
  # executor has to run in a fresh fiber to start from an empty effect stack.
  def execute_in_fresh_fiber
    Fiber.new do
      executor.()
    ensure
      ApplicationRecord.connection_pool.release_connection
    end.resume
  end

  it "runs nested effect handlers in the transaction's fiber and connection" do
    execute_in_fresh_fiber

    expect(operation.observed[:inner]).to eq operation.observed[:outer]
  end
end
