# frozen_string_literal: true

RSpec.describe MatomoComponent, type: :component do
  it "renders script tags when enabled" do
    expect(
      render_inline(described_class.new(config: MatomoConfig.new(enabled: true))).css("script")
    ).to have(2).items
  end

  it "renders nothing when disabled" do
    expect(
      render_inline(described_class.new(config: MatomoConfig.new(enabled: false))).css("script")
    ).to be_blank
  end
end
