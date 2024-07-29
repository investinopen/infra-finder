# frozen_string_literal: true

RSpec.describe SolutionProperties::LoadExisting, type: :operation do
  it "generates an indexed mapping of the current properties for parsing / iteration" do
    expect_calling.to succeed.with(a_kind_of(Hash).and(be_present))
  end
end
