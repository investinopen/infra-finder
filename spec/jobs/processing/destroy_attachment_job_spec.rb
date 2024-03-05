# frozen_string_literal: true

RSpec.describe Processing::DestroyAttachmentJob, type: :job do
  let_it_be(:solution) { FactoryBot.create :solution }

  before do
    perform_enqueued_jobs do
      solution.logo = Rails.root.join("spec", "data", "lorempixel.jpg").open("r+")
      solution.save!
    end

    solution.reload
  end

  it "works as expected with backgrounded attachments" do
    expect(solution.logo).to be_present

    expect do
      solution.destroy!
    end.to have_enqueued_job(described_class).once
      .and change(Solution, :count).by(-1)

    perform_enqueued_jobs
  end
end
