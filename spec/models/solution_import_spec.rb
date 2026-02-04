# frozen_string_literal: true

RSpec.describe SolutionImport, type: :model do
  specify "creating a new import will process in the background" do
    expect do
      FactoryBot.create(:solution_import, skip_process: false)
    end.to have_enqueued_job(SolutionImports::ProcessJob).once
  end

  specify "background processing can be skipped" do
    expect do
      FactoryBot.create(:solution_import, skip_process: true)
    end.not_to have_enqueued_job(SolutionImports::ProcessJob)
  end

  specify "it synchronously promotes the import when created" do
    import = FactoryBot.build(:solution_import, skip_process: true)

    expect do
      import.save!
    end.to change(described_class, :count).by(1)
      .and change { import.source.storage_key }.from(:cache).to(:store)
      .and have_enqueued_no_jobs(SolutionImports::ProcessJob)
      .and have_enqueued_no_jobs(Processing::PromoteAttachmentJob)
  end
end
