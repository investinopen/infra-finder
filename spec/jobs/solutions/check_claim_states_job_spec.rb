# frozen_string_literal: true

RSpec.describe Solutions::CheckClaimStatesJob, type: :job do
  it_behaves_like "a void operation job", "solutions.check_claim_states"
end
