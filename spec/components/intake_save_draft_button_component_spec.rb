# frozen_string_literal: true

RSpec.describe IntakeSaveDraftButtonComponent, type: :component do
  let(:button) { render_inline(described_class.new).at_css("button") }

  it "renders a button wired to its controller" do
    expect(button["type"]).to eq("button")
    expect(button["data-controller"]).to eq(described_class::CONTROLLER)
    expect(button.text.strip).to eq("Save Draft")
  end

  it "does not submit the form itself" do
    expect(button["form"]).to be_nil
    expect(button["name"]).to be_nil
  end

  it "asks the form to save, and listens for how that save is going" do
    actions = button["data-action"].split

    expect(actions).to contain_exactly(
      "#{described_class::CONTROLLER}#save",
      "#{described_class::SAVING_EVENT}@window->#{described_class::CONTROLLER}#saving",
      "#{described_class::SAVED_EVENT}@window->#{described_class::CONTROLLER}#saved",
      "#{described_class::SAVE_FAILED_EVENT}@window->#{described_class::CONTROLLER}#fail",
    )
  end

  it "hands its controller the labels to report progress with" do
    labels = JSON.parse(button["data-#{described_class::CONTROLLER}-labels-value"])

    expect(labels).to eq(
      "idle" => "Save Draft",
      "autosaving" => "Autosaving…",
      "saving" => "Saving…",
      "saved" => "Saved!",
    )
  end
end
