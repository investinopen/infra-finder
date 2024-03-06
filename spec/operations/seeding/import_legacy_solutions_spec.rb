# frozen_string_literal: true

RSpec.describe Seeding::ImportLegacySolutions, type: :operation do
  stub_operation! "solution_imports.process", as: :import_process, auto_succeed: true

  it "works as expected" do
    expect_calling.to succeed

    expect(import_process).to have_received(:call).once
  end
end
