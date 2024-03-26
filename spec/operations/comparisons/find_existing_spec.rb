# frozen_string_literal: true

RSpec.describe Comparisons::FindExisting, type: :operation do
  let_it_be(:session_id) { SecureRandom.hex(16) }

  context "when a comparison for the current session is existing" do
    let_it_be(:comparison, refind: true) { FactoryBot.create :comparison, session_id: }

    it "finds the comparison" do
      expect_calling_with(comparison.session_id).to succeed.with comparison
    end
  end

  context "when a comparison for the current session is not existing" do
    before do
      Comparison.where(session_id:).delete_all
    end

    it "does not find the comparison" do
      expect_calling_with(session_id).to monad_fail.with_key(:not_found)
    end
  end
end
