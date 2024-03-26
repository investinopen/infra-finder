# frozen_string_literal: true

RSpec.describe FlashMessageComponent, type: :component do
  it "renders flash messages with different styles", :aggregate_failures do
    expect(render_preview(:success).to_html).to include "some message"
    expect(render_preview(:error).to_html).to include "some message"
    expect(render_preview(:alert).to_html).to include "some message"
    expect(render_preview(:warning).to_html).to include "some message"
    expect(render_preview(:notice).to_html).to include "some message"
    expect(render_preview(:other).to_html).to include "some message"
  end
end
