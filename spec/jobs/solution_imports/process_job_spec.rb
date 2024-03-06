# frozen_string_literal: true

RSpec.describe SolutionImports::ProcessJob, type: :job do
  let_it_be(:solution_import) { FactoryBot.create :solution_import }

  it_behaves_like "a pass-through operation job", "solution_imports.process" do
    let(:job_arg) { solution_import }
  end
end
