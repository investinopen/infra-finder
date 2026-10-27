# frozen_string_literal: true

RSpec.describe SolutionDraft, type: :model do
  let_it_be(:solution, refind: true) { FactoryBot.create :solution }
  let_it_be(:user, refind: true) { FactoryBot.create :user }

  describe "the solution's draft counts" do
    def counts
      solution.reload.slice(:all_drafts_count, :pending_and_in_review_drafts_count).values
    end

    it "tracks drafts through their states" do
      draft = nil

      expect { draft = solution.create_draft!(user:) }.to change { counts }.from([0, 0]).to([1, 1])

      expect { draft.transition_to!(:in_review) }.to keep_the_same { counts }

      expect { draft.transition_to!(:rejected) }.to change { counts }.to([1, 0])

      expect { draft.destroy! }.to change { counts }.to([0, 0])
    end
  end
end
