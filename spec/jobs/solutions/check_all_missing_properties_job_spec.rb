# frozen_string_literal: true

RSpec.describe Solutions::CheckAllMissingPropertiesJob, type: :job do
  let_it_be(:solution, refind: true) { FactoryBot.create :solution }
  let_it_be(:solution_draft, refind: true) { solution.create_draft!(user: FactoryBot.create(:user)) }
  let_it_be(:solution_intake, refind: true) { FactoryBot.create :solution_intake }

  it "enqueues a job for every solution, draft, and intake" do
    expect do
      described_class.perform_now
    end.to have_enqueued_job(Solutions::CheckMissingPropertiesJob).with(solution)
      .and have_enqueued_job(Solutions::CheckMissingPropertiesJob).with(solution_draft)
      .and have_enqueued_job(Solutions::CheckMissingPropertiesJob).with(solution_intake)
  end
end
