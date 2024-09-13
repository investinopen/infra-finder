# frozen_string_literal: true

RSpec.describe Solutions::CheckFlagsJob, type: :job do
  pending "add some examples to (or delete) #{__FILE__}"

  let_it_be(:solution, refind: true) { FactoryBot.create :solution }

  it_behaves_like "a pass-through operation job", "solutions.check_flags" do
    let(:job_arg) { solution }
  end
end
