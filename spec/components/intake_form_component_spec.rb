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

  describe "#form_data" do
    subject(:component) { described_class.new(solution_intake:) }

    it "asks the client to confirm navigating away" do
      expect(component.form_data[:action])
        .to include("beforeunload@window->#{described_class::CONTROLLER}#confirmExit")
    end

    it "delegates autosave to focus entering and leaving a field" do
      expect(component.form_data[:action])
        .to include("focusin->#{described_class::CONTROLLER}#fieldFocus")
        .and include("focusout->#{described_class::CONTROLLER}#fieldBlur")
    end
  end

  describe "#dirty?" do
    let(:solution_intake) { SolutionIntake.new }

    subject(:component) { described_class.new(solution_intake:) }

    it "is false for an intake the server has accepted" do
      expect(component.dirty?).to be(false)
      expect(component.form_data).to include("#{described_class::CONTROLLER}-dirty-value": false)
    end

    it "is true when a rejected submission renders its values back" do
      solution_intake.errors.add(:name, :blank)

      expect(component.dirty?).to be(true)
      expect(component.form_data).to include("#{described_class::CONTROLLER}-dirty-value": true)
    end
  end

  describe "field errors" do
    it "renders the single element the field wrappers read their errors from" do
      rendered = render_inline(described_class.new(solution_intake:))

      elements = rendered.css("form [data-field-errors]")

      expect(elements.length).to eq(1)
      expect(elements.first["id"]).to eq(IntakeFieldErrorsComponent::ID)
    end
  end
end
