# frozen_string_literal: true

RSpec.describe Solutions::Revisions::BackfillInitial, type: :operation do
  let_it_be(:solution_with_revision, refind: true) { FactoryBot.create(:solution) }
  let_it_be(:solution_sans_revision, refind: true) { FactoryBot.create(:solution) }

  before do
    solution_with_revision.initialize_revision!
  end

  it "only backfills revisions for solutions without an initial revision" do
    expect do
      expect_calling.to succeed
    end.to change(SolutionRevision, :count).by(1)
  end
end
