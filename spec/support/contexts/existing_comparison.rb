# frozen_string_literal: true

RSpec.shared_context "existing comparison" do
  let_it_be(:current_comparison, refind: true) { FactoryBot.create :comparison }

  stub_operation! "comparisons.fetch", as: :fetch_comparison, auto_succeed: false
  stub_operation! "comparisons.find_existing", as: :find_existing_comparison, auto_succeed: false

  before do
    allow(fetch_comparison).to receive(:call).and_return(Dry::Monads.Success(current_comparison))
    allow(find_existing_comparison).to receive(:call).and_return(Dry::Monads.Success(current_comparison))
  end
end
