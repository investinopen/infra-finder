# frozen_string_literal: true

RSpec.describe IntakeFormHelpComponent, type: :component do
  it "renders a collapsed details disclosure with an icon-only, labeled summary" do
    rendered = render_inline(described_class.new(for_title: "About"))

    details = rendered.at_css("details.help-details")
    summary = rendered.at_css("summary")

    expect(details).to be_present
    expect(details.key?("open")).to be(false)
    expect(summary["aria-label"]).to eq("Help for the About section")
    expect(summary.at_css("svg")).to be_present
  end

  it "renders the help text with a definitions link at the given href" do
    rendered = render_inline(described_class.new(href: "https://example.com/defs#about"))

    link = rendered.at_css(".help-details__content a")

    expect(link["href"]).to eq("https://example.com/defs#about")
    expect(link.text).to eq("definitions and examples")
    expect(rendered.at_css(".help-details__content").text).to include("for the fields in this section")
  end

  it "falls back to a no-op href when none is given" do
    rendered = render_inline(described_class.new)

    expect(rendered.at_css(".help-details__content a")["href"]).to eq("#")
  end
end
