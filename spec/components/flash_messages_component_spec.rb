# frozen_string_literal: true

RSpec.describe FlashMessagesComponent, type: :component do
  it "renders flash messages" do
    expect(render_preview(:kitchen_sink).to_html).to be_present
  end

  it "skips over weird flash messages" do
    flash = ActionDispatch::Flash::FlashHash.new

    flash[:success] = "true"
    flash[:error] = true

    expect(render_inline(described_class.new(flash:)).css("[data-controller]").to_html).to be_blank
  end
end
