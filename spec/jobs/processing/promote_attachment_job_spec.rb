# frozen_string_literal: true

RSpec.describe Processing::PromoteAttachmentJob, type: :job do
  let_it_be(:solution) { FactoryBot.create :solution }

  it "works as expected with backgrounded attachments" do
    expect do
      solution.logo = Rails.root.join("spec", "data", "lorempixel.jpg").open("r+")
      solution.save!
    end.to have_enqueued_job(described_class).once

    perform_enqueued_jobs
  end
end
