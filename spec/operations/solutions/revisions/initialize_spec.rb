# frozen_string_literal: true

RSpec.describe Solutions::Revisions::Initialize, type: :operation do
  let_it_be(:solution, refind: true) { FactoryBot.create(:solution) }

  it "creates an initial revision" do
    expect do
      expect_calling_with(solution).to succeed
    end.to change(SolutionRevision, :count).by(1)
  end

  context "when an initial revision already exists" do
    before do
      solution.initialize_revision!
    end

    it "does nothing" do
      expect do
        expect_calling_with(solution).to succeed
      end.to keep_the_same(SolutionRevision, :count)
    end
  end
end
