# frozen_string_literal: true

RSpec.describe IntakeFormSectionComponent, type: :component do
  it "renders the title as a legend and its content inside the grid" do
    rendered = render_inline(described_class.new(title: "About your solution", help: false)) do
      '<div class="form-field-wrapper"><input name="name"></div>' \
        '<div class="form-field-wrapper"><input name="url"></div>'.html_safe
    end

    expect(rendered.at_css("fieldset legend").text.strip).to eq("About your solution")
    expect(rendered.at_css("fieldset")["id"]).to be_nil
    expect(rendered.css(".form-grid > .form-field-wrapper").length).to eq(2)
    expect(rendered.at_css(".form-grid input[name='name']")).to be_present
    expect(rendered.at_css(".form-grid input[name='url']")).to be_present
  end

  it "sets the fieldset id from the anchor for nav scroll targets" do
    rendered = render_inline(described_class.new(title: "Overview", anchor: "overview"))

    expect(rendered.at_css("fieldset")["id"]).to eq("overview")
  end

  it "renders the title plus a help disclosure in the legend by default" do
    rendered = render_inline(described_class.new(title: "Overview"))

    legend = rendered.at_css("legend")

    expect(legend.at_css("details.help-details")).to be_present
    expect(legend.text).to include("Overview")
    # The title lives in the legend, outside the details element.
    expect(legend.at_css("details").text).not_to include("Overview")
  end

  it "omits the help disclosure when help is false" do
    rendered = render_inline(described_class.new(title: "Overview", help: false))

    expect(rendered.at_css("legend details")).to be_nil
    expect(rendered.at_css("legend").text.strip).to eq("Overview")
  end
end
