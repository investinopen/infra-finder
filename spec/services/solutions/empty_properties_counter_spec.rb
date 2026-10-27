# frozen_string_literal: true

RSpec.describe Solutions::EmptyPropertiesCounter do
  let_it_be(:solution, refind: true) { FactoryBot.create :solution }

  def empty?(name)
    SolutionProperty.find(name).accessor.empty?(solution)
  end

  describe "counted properties" do
    it "follows the kind and excludes meta and hidden properties" do
      expect(SolutionProperty.find("fiscal_host")).to be_counted_when_empty
      expect(SolutionProperty.find("created_at")).not_to be_counted_when_empty
      expect(SolutionProperty.find("annual_expenses")).not_to be_counted_when_empty
      expect(SolutionProperty.find("bylaws")).not_to be_counted_when_empty
    end
  end

  describe "emptiness" do
    it "treats blank text as empty" do
      solution.fiscal_host = " "

      expect(empty?("fiscal_host")).to be true

      solution.fiscal_host = "Someone"

      expect(empty?("fiscal_host")).to be false
    end

    it "treats only a missing boolean as empty" do
      solution.shareholders = nil

      expect(empty?("shareholders")).to be true

      solution.shareholders = false

      expect(empty?("shareholders")).to be false
    end

    it "treats an unknown implementation status as empty" do
      solution.code_license_implementation = "unknown"

      expect(empty?("code_license_implementation")).to be true

      solution.code_license_implementation = "available"

      expect(empty?("code_license_implementation")).to be false
    end

    it "treats a missing or unknown single option as empty" do
      expect(empty?("hosting_strategy")).to be true

      solution.hosting_strategy = FactoryBot.create(:hosting_strategy, provides: :unknown)

      expect(empty?("hosting_strategy")).to be_truthy

      solution.hosting_strategy = FactoryBot.create(:hosting_strategy)

      expect(empty?("hosting_strategy")).to be_falsey
    end

    it "treats no options, or only unknown ones, as empty" do
      expect(empty?("solution_categories")).to be true

      solution.solution_categories = [FactoryBot.create(:solution_category, provides: :unknown)]

      expect(empty?("solution_categories")).to be true

      solution.solution_categories += [FactoryBot.create(:solution_category)]

      expect(empty?("solution_categories")).to be false
    end
  end

  describe "#call" do
    it "counts one fewer once a property is filled" do
      expect do
        solution.update!(fiscal_host: "Someone")
      end.to change(solution, :empty_properties_count).by(-1)
    end
  end
end
