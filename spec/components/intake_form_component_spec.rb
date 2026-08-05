# frozen_string_literal: true

RSpec.describe IntakeFormComponent, type: :component do
  before_all do
    InfraFinder::Container["controlled_vocabularies.upsert_all_records"].().value!
  end

  let_it_be(:solution_intake) { FactoryBot.create(:solution_intake) }

  it "renders a form that submits to the intake's update path" do
    rendered = render_inline(described_class.new(solution_intake:))

    form = rendered.at_css("form")

    expect(form["action"]).to eq("/intake/#{solution_intake.slug}")
    expect(form["method"]).to eq("post")
    expect(form["id"]).to eq(described_class::FORM_ID)
    expect(rendered.at_css("input[type='submit']")["value"]).to eq("Submit")
  end

  it "resolves a trigger value for every conditional field" do
    rendered = render_inline(described_class.new(solution_intake:))

    unresolved = rendered
      .css("[data-condition-field]")
      .reject { _1["data-condition-value"].present? }
      .pluck("data-condition-field")

    expect(unresolved).to be_empty
  end

  describe "#vocab_option_value" do
    subject(:component) { described_class.new(solution_intake:) }

    it "resolves a model-backed option to its id" do
      other = BusinessForm.find_by!(term: "Other")

      expect(component.vocab_option_value("bus_form", "Other")).to eq(other.id)
    end

    it "matches the canonical term rather than the editable display label" do
      other = BusinessForm.find_by!(term: "Other")
      other.update!(name: "Other (please specify)")

      expect(component.vocab_option_value("bus_form", "Other")).to eq(other.id)
    end

    it "is nil for a term the vocabulary doesn't have" do
      expect(component.vocab_option_value("bus_form", "Nonexistent")).to be_nil
    end

    it "resolves each term when given several" do
      expect(component.vocab_option_values("saas", "Through third party vendor only", "Nope"))
        .to eq([HostingStrategy.find_by!(term: "Through third party vendor only").id, nil])
    end
  end

  describe "#field_errors" do
    let(:solution_intake) { SolutionIntake.new }

    subject(:component) { described_class.new(solution_intake:) }

    it "is an empty payload when the intake is valid" do
      expect(component.field_errors).to eq("[]")
    end

    it "addresses each error by the name of the input that posts it" do
      solution_intake.errors.add(:name, :blank)

      expect(JSON.parse(component.field_errors))
        .to eq([{ "name" => "solution_intake[name]", "message" => "can't be blank" }])
    end

    it "is exposed to the client on the form element" do
      expect(component.form_data).to include(field_errors: component.field_errors)
    end
  end
end
