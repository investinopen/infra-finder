# frozen_string_literal: true

RSpec.describe IntakeErrorSummaryComponent, type: :component do
  let(:solution_intake) { SolutionIntake.new }

  it "renders nothing when the intake has no errors" do
    rendered = render_inline(described_class.new(solution_intake:))

    expect(rendered.at_css(".intake-error-summary")).to be_nil
  end

  context "when the intake has errors" do
    before do
      solution_intake.errors.add(:name, :blank)
      solution_intake.code_repository.errors.add(:links, :invalid)
      solution_intake.errors.add(:code_repository, :invalid)
    end

    it "renders an alert that takes focus" do
      summary = render_inline(described_class.new(solution_intake:)).at_css(".intake-error-summary")

      expect(summary["role"]).to eq("alert")
      expect(summary["tabindex"]).to eq("-1")
    end

    it "lists every error with its attribute label" do
      rendered = render_inline(described_class.new(solution_intake:))

      expect(rendered.css(".intake-error-summary__list li").map(&:text))
        .to eq(["Name can't be blank", "Code repository: Links is invalid"])
    end

    it "tags each entry with the name of the input it belongs to" do
      rendered = render_inline(described_class.new(solution_intake:))

      expect(rendered.css(".intake-error-summary__list li").pluck("data-field-name"))
        .to eq([
                 "solution_intake[name]",
                 "solution_intake[code_repository_attributes][links][][url]",
               ])
    end
  end
end
