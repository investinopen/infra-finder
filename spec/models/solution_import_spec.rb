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
end
