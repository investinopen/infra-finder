# frozen_string_literal: true

RSpec.describe SolutionImports::Process, type: :operation do
  let_it_be(:strategy) { "legacy" }
  let_it_be(:solution_import, refind: true) { FactoryBot.create(:solution_import, strategy:) }

  before_all do
    InfraFinder::Container["seeding.seed_all_options"].().value!
  end

  stub_operation! "solution_drafts.check", as: :stubbed_draft_check, auto_succeed: true

  before do
    csv = solution_import.source.download do |f|
      CSV.table(f)
    end
  rescue Errno::ENOENT, MalformedCSVError
    # intentionally left blank
  else
    image_urls = csv.pluck(:service_logo).map do |url|
      case url
      when /\ANULL\z/i then nil
      when SolutionImports::Types::URL
        uri = URI.parse(url)

        # There's some silly stuff here
        uri.fragment = nil

        uri.to_s
      end
    end.compact_blank.uniq

    image_urls.each_with_index do |url, index|
      # We'll alternate failures to test the failure url logic
      if index.even?
        body = Rails.root.join("spec", "data", "lorempixel.jpg").open("r+")

        stub_request(:get, url).to_return(body:)
      else
        stub_request(:get, url).to_return(body: "Not Found", status: 404)
      end
    end
  end

  context "with a legacy import" do
    context "when given valid inputs" do
      it "will process and import providers and solutions" do
        expect do
          expect_calling_with(solution_import).to succeed
        end.to change { solution_import.current_state(force_reload: true) }.from("pending").to("success")
          .and change(Provider, :count).by(52)
          .and change(Solution, :count).by(57)
          .and change(SolutionDraft, :count).by(57)
          .and change(SolutionDraft.approved, :count).by(57)

        aggregate_failures do
          expect(solution_import).to have_attributes(providers_count: 52, solutions_count: 57)

          expect(solution_import.messages).to be_present
        end
      end
    end

    context "when the import is not still pending" do
      before do
        solution_import.transition_to!(:started)
      end

      it "will fail to process" do
        expect do
          expect_calling_with(solution_import).to be_a_monadic_failure.with_key(:invalid_state)
        end.to keep_the_same { solution_import.current_state(force_reload: true) }
      end
    end
  end

  context "with a modern import" do
    let_it_be(:strategy) { "modern" }
    let_it_be(:solution_import, refind: true) { FactoryBot.create(:solution_import, strategy:) }

    context "when given valid inputs" do
      it "is not supported" do
        expect do
          expect_calling_with(solution_import).to succeed
        end.to change { solution_import.current_state(force_reload: true) }.from("pending").to("invalid")

        expect(solution_import.messages).to be_present
      end
    end
  end
end
