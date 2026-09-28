# frozen_string_literal: true

RSpec.describe SolutionClaimAlertComponent, type: :component do
  let_it_be(:solution, refind: true) { FactoryBot.create :solution, :barebones }

  let(:component) { described_class.new(solution:) }

  context "when the solution is unclaimed" do
    it "links to the claim form" do
      rendered = render_inline component

      expect(rendered.css("h2").text).to eq "This Profile is Currently Unclaimed"

      link = rendered.at_css("a")

      expect(link["href"]).to eq solution.claim_form_url
      expect(link["target"]).to eq "_blank"
      expect(link.text).to include "Claim this Profile"
    end

    context "when the claim form is unavailable" do
      before do
        allow(ClaimFormConfig).to receive(:available?).and_return(false)
      end

      it "renders nothing" do
        expect(render_inline(component).to_html).to be_blank
      end
    end
  end

  context "when the solution is claimed" do
    let_it_be(:user, refind: true) { FactoryBot.create :user }

    before do
      solution.assign_editor!(user)

      perform_enqueued_jobs(only: Solutions::CheckClaimStatesJob)

      solution.reload
    end

    it "renders nothing" do
      expect(render_inline(component).to_html).to be_blank
    end
  end
end
