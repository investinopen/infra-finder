# frozen_string_literal: true

RSpec.describe TypeaheadComponent, type: :component do
  let(:form) do
    ActionView::Helpers::FormBuilder.new(:solution_intake, nil, vc_test_controller.view_context, {})
  end

  def render_component(**opts)
    component = described_class.new(form:, attr: :solution_categories, vocab_name: "soln_cat", **opts)
    allow(component).to receive(:options).and_return(
      [["Repository hosting", "repo", {}], ["Identifier registry", "registry", {}]]
    )
    render_inline(component)
  end

  it "renders a native multiple select that submits array params" do
    result = render_component
    select = result.at_css("select")

    expect(select["name"]).to eq("solution_intake[solution_categories][]")
    expect(select["multiple"]).not_to be_nil
    expect(result.at_css("option[value='repo']").text).to eq("Repository hosting")
    expect(result.at_css("option[value='registry']").text).to eq("Identifier registry")
  end

  it "does not emit a hidden fallback field when nothing is selected" do
    result = render_component

    expect(result.css("input[type='hidden']")).to be_empty
  end

  it "wires up the Stimulus controller and value attributes" do
    result = render_component(labelled_by: "cats-label", max_items: 3, placeholder: "Search…",
                              max_items_placeholder: "Maximum of 3 selected")
    select = result.at_css("select")

    expect(select["data-controller"]).to include("typeahead-component--typeahead-component")
    expect(select["data-typeahead-component--typeahead-component-max-items-value"]).to eq("3")
    expect(select["data-typeahead-component--typeahead-component-placeholder-value"]).to eq("Search…")
    expect(select["data-typeahead-component--typeahead-component-max-items-placeholder-value"])
      .to eq("Maximum of 3 selected")
    expect(select["aria-labelledby"]).to eq("cats-label")
  end

  it "omits the value attributes when max_items and placeholder are not given" do
    result = render_component
    select = result.at_css("select")

    expect(select["data-typeahead-component--typeahead-component-max-items-value"]).to be_nil
    expect(select["data-typeahead-component--typeahead-component-max-items-placeholder-value"]).to be_nil
  end
end
