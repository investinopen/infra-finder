# frozen_string_literal: true

RSpec.describe SolutionProperties::Parse, type: :operation do
  let(:output_path) { Rails.root.join("tmp", "properties.yml") }

  before do
    output_path.unlink if output_path.exist?
  end

  it "generates a YAML dump from the cleaned up CSV export" do
    expect do
      expect_calling_with(output_path:).to succeed
    end.to change(output_path, :exist?).from(false).to(true)
  end
end
