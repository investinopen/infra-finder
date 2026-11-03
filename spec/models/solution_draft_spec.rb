# frozen_string_literal: true

RSpec.describe SolutionDraft, type: :model do
  let_it_be(:solution, refind: true) { FactoryBot.create :solution }
  let_it_be(:user, refind: true) { FactoryBot.create :user }

  describe "the solution's draft counts" do
    def counts
      solution.reload.slice(:all_drafts_count, :pending_and_in_review_drafts_count).values
    end

    it "tracks drafts through their states" do
      draft = nil

      expect { draft = solution.create_draft!(user:) }.to change { counts }.from([0, 0]).to([1, 1])

      expect { draft.transition_to!(:in_review) }.to keep_the_same { counts }

      expect { draft.transition_to!(:rejected) }.to change { counts }.to([1, 0])

      expect { draft.destroy! }.to change { counts }.to([0, 0])
    end
  end

  describe "enqueuing updates to open drafts" do
    it "enqueues a job for each open draft" do
      expect do
        solution.update!(service_summary: "No drafts")
      end.not_to have_enqueued_job(SolutionDrafts::UpdateFromSolutionJob)

      draft = solution.create_draft!(user:)
      other_draft = solution.create_draft!(user: FactoryBot.create(:user))

      expect do
        solution.update!(service_summary: "Solution summary")
      end.to have_enqueued_job(SolutionDrafts::UpdateFromSolutionJob).with(draft).once
        .and have_enqueued_job(SolutionDrafts::UpdateFromSolutionJob).with(other_draft).once
    end

    it "skips a draft that was finalized before its job ran" do
      draft = solution.create_draft!(user:)
      draft.transition_to!(:in_review)
      draft.transition_to!(:rejected)

      solution.update_columns(service_summary: "Solution summary")

      expect do
        expect(draft.update_from_solution).to be_success
      end.to keep_the_same { draft.reload.service_summary }
    end
  end

  describe "updating open drafts from the solution" do
    let!(:draft) { solution.create_draft!(user:) }

    around do |example|
      perform_enqueued_jobs(only: SolutionDrafts::UpdateFromSolutionJob) { example.run }
    end

    before do
      draft.update!(mission: "Draft mission")
    end

    it "saves the solution and other drafts when a draft is invalid" do
      other_draft = solution.create_draft!(user: FactoryBot.create(:user))

      draft.update_columns(website: "not a url", draft_overrides: %w[mission website])

      expect do
        solution.update!(service_summary: "Solution summary")
      end.to change { solution.reload.service_summary }.to("Solution summary")
        .and change { other_draft.reload.service_summary }.to("Solution summary")
        .and keep_the_same { draft.reload.service_summary }
    end

    it "copies solution changes into properties the draft has not overridden" do
      solution.update!(mission: "Solution mission", service_summary: "Solution summary")

      draft.reload

      expect(draft).to have_attributes(
        mission: "Draft mission",
        service_summary: "Solution summary",
        draft_overrides: ["mission"]
      )
    end

    it "keeps the solution's changes when the draft is saved again" do
      solution.update!(service_summary: "Solution summary")

      draft.reload.update!(governance_summary: "Draft governance")

      expect(draft.reload.draft_overrides).to eq %w[governance_summary mission]
    end

    it "keeps association changes made in the draft" do
      category = FactoryBot.create :solution_category

      draft.update!(solution_categories: [category])

      expect(draft.reload.draft_overrides).to include "solution_categories"

      solution.update!(service_summary: "Solution summary")

      expect(draft.reload.solution_categories).to contain_exactly category
    end

    it "leaves finalized drafts alone" do
      draft.transition_to!(:in_review)
      draft.transition_to!(:rejected)

      expect do
        solution.update!(service_summary: "Solution summary")
      end.to keep_the_same { draft.reload.service_summary }
    end
  end

  describe "updating open drafts for each kind of property" do
    let_it_be(:logo_svg) { Rails.root.join("spec/data/logo.svg") }
    let_it_be(:logo_jpg) { Rails.root.join("spec/data/lorempixel.jpg") }

    let!(:draft) { solution.create_draft!(user:).tap { _1.transition_to!(:in_review) } }

    around do |example|
      perform_enqueued_jobs(only: SolutionDrafts::UpdateFromSolutionJob) { example.run }
    end

    shared_examples "an open draft property" do |attribute|
      it "copies the solution's #{attribute} when the draft has not changed it" do
        expect do
          solution.update!(attribute => solution_value)
        end.to change { read_value.(draft.reload) }

        expect(read_value.(draft)).to eq read_value.(solution.reload)
      end

      it "keeps the draft's #{attribute} when the draft has changed it" do
        draft.update!(attribute => draft_value)

        expect(draft.reload.draft_overrides).to include attribute.to_s

        expect do
          solution.update!(attribute => solution_value)
        end.to keep_the_same { read_value.(draft.reload) }
      end
    end

    context "with a string" do
      let(:solution_value) { "Solution name" }
      let(:draft_value) { "Draft name" }
      let(:read_value) { ->(record) { record.name } }

      include_examples "an open draft property", :name
    end

    context "with money" do
      let(:solution_value) { 100 }
      let(:draft_value) { 200 }
      let(:read_value) { ->(record) { record.total_contributions_cents } }

      include_examples "an open draft property", :total_contributions
    end

    context "with a single option" do
      let(:solution_value) { FactoryBot.create :hosting_strategy }
      let(:draft_value) { FactoryBot.create :hosting_strategy }
      let(:read_value) { ->(record) { record.hosting_strategy } }

      include_examples "an open draft property", :hosting_strategy
    end

    context "with multiple options" do
      let(:solution_value) { [FactoryBot.create(:solution_category)] }
      let(:draft_value) { [FactoryBot.create(:solution_category)] }
      let(:read_value) { ->(record) { record.solution_categories.to_a } }

      include_examples "an open draft property", :solution_categories
    end

    context "with a free input" do
      let(:solution_value) { "Solution activity" }
      let(:draft_value) { "Draft activity" }
      let(:read_value) { ->(record) { record.community_engagement_activity_other } }

      include_examples "an open draft property", :community_engagement_activity_other
    end

    context "with a store model list" do
      let(:solution_value) { [Structured::Institution.new(name: "Solution institution")] }
      let(:draft_value) { [Structured::Institution.new(name: "Draft institution")] }
      let(:read_value) { ->(record) { record.current_affiliations.map(&:name) } }

      include_examples "an open draft property", :current_affiliations
    end

    context "with an implementation" do
      let(:solution_value) { Implementations::Bylaws.new(statement: "Solution statement") }
      let(:draft_value) { Implementations::Bylaws.new(statement: "Draft statement") }
      let(:read_value) { ->(record) { record.bylaws.statement } }

      include_examples "an open draft property", :bylaws
    end

    context "with an implementation status" do
      let(:solution_value) { "available" }
      let(:draft_value) { "in_progress" }
      let(:read_value) { ->(record) { record.bylaws_implementation } }

      include_examples "an open draft property", :bylaws_implementation
    end

    context "with an attachment" do
      let(:solution_value) { logo_svg.open("r") }
      let(:draft_value) { logo_jpg.open("rb") }
      let(:read_value) { ->(record) { record.logo&.metadata&.fetch("filename") } }

      include_examples "an open draft property", :logo
    end
  end
end
