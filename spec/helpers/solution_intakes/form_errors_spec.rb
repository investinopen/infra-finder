# frozen_string_literal: true

RSpec.describe SolutionIntakes::FormErrors do
  let(:solution_intake) { SolutionIntake.new }

  subject(:form_errors) { described_class.new(solution_intake) }

  it "is empty when the intake has no errors" do
    expect(form_errors).not_to be_any
    expect(form_errors.entries).to be_empty
    expect(form_errors.field_data).to be_empty
  end

  context "with an error on a plain attribute" do
    before { solution_intake.errors.add(:name, :blank) }

    it "qualifies the summary message and leaves the inline detail bare" do
      entry = form_errors.entries.sole

      expect(entry.message).to eq("Name can't be blank")
      expect(entry.detail).to eq("can't be blank")
      expect(entry.field_name).to eq("solution_intake[name]")
    end

    it "addresses the field by the name its input posts under" do
      expect(form_errors.field_data)
        .to eq([{ name: "solution_intake[name]", message: "can't be blank" }])
    end
  end

  context "with an error on an implementation store model" do
    before do
      solution_intake.code_repository.errors.add(:links, :invalid)
      solution_intake.errors.add(:code_repository, :invalid)
    end

    it "reads the message off the nested record rather than reporting 'is invalid'" do
      entry = form_errors.entries.sole

      expect(entry.message).to eq("Code repository: Links is invalid")
      expect(entry.detail).to eq("Links is invalid")
    end

    it "addresses the name IntakeFormComponent#implementation_url_field emits" do
      expect(form_errors.entries.sole.field_name)
        .to eq("solution_intake[code_repository_attributes][links][][url]")
    end
  end

  context "with an error on a store model list row" do
    before do
      solution_intake.current_affiliations = [Solutions::Institution.new(url: "nope")]
      solution_intake.current_affiliations.first.errors.add(:url, :invalid)
      solution_intake.errors.add(:current_affiliations, :invalid)
    end

    it "keeps the row number in both messages, since one wrapper renders every row" do
      entry = form_errors.entries.sole

      expect(entry.message).to eq("Current affiliations, row 1: URL is invalid")
      expect(entry.detail).to eq("Row 1: URL is invalid")
    end

    it "addresses the row's own input" do
      expect(form_errors.entries.sole.field_name)
        .to eq("solution_intake[current_affiliations_attributes][0][url]")
    end
  end

  context "with errors on several attributes" do
    before do
      solution_intake.errors.add(:name, :blank)
      solution_intake.errors.add(:website, :blank)
    end

    it "returns one entry per error" do
      expect(form_errors.entries.map(&:field_name))
        .to contain_exactly("solution_intake[name]", "solution_intake[website]")
    end
  end
end
