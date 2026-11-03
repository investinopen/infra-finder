# frozen_string_literal: true

RSpec.describe Solutions::CheckMissingPropertiesJob, type: :job do
  let_it_be(:solution, refind: true) { FactoryBot.create :solution }

  it_behaves_like "a pass-through operation job", "solutions.check_missing_properties" do
    let(:job_arg) { solution }
  end
end
