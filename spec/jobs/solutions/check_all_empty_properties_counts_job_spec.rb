# frozen_string_literal: true

RSpec.describe Solutions::CheckAllEmptyPropertiesCountsJob, type: :job do
  let_it_be(:solution, refind: true) { FactoryBot.create :solution }

  it "enqueues a job for every solution" do
    expect do
      described_class.perform_now
    end.to have_enqueued_job(Solutions::CheckEmptyPropertiesCountJob).once.with(solution)
  end
end
