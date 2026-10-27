# frozen_string_literal: true

RSpec.describe Solutions::CheckEmptyPropertiesCountJob, type: :job do
  let_it_be(:solution, refind: true) { FactoryBot.create :solution }

  it_behaves_like "a pass-through operation job", "solutions.check_empty_properties_count" do
    let(:job_arg) { solution }
  end
end
