# frozen_string_literal: true

RSpec.describe SolutionImports::Process, type: :operation do
  before_all do
    InfraFinder::Container["controlled_vocabularies.upsert_all_records"].().value!
  end

  # @param [SolutionProperty] property
  # @return [void]
  def stub_urls_for!(property)
    csv = solution_import.source.download do |f|
      CSV.table(f)
    end
  rescue Errno::ENOENT, MalformedCSVError
    # intentionally left blank
  else
    image_urls = csv.pluck(property.csv_header.to_sym).map do |url|
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

  context "with an EOI import" do
    let_it_be(:strategy) { :eoi }
    let_it_be(:solution_import, refind: true) { FactoryBot.create(:solution_import, strategy, auto_approve: false) }

    let_it_be(:existing_provider, refind: true) { FactoryBot.create(:provider, name: "EOI Test Provider") }
    let_it_be(:existing_solution, refind: true) { FactoryBot.create(:solution, provider: existing_provider, name: "EOI Test solution") }

    context "when given valid inputs and auto_approve turned off" do
      it "is supported" do
        expect do
          expect_calling_with(solution_import).to succeed
        end.to change { solution_import.current_state(force_reload: true) }.from("pending").to("success")
          .and change(Solution.unpublished, :count).by(1)
          .and change(Provider, :count).by(1)
          .and change(SolutionDraft, :count).by(2)
          .and change(SolutionDraft.in_review, :count).by(2)
          .and keep_the_same(Solution.published, :count)
          .and keep_the_same(SolutionDraft.approved, :count)

        aggregate_failures do
          expect(solution_import).to have_attributes(providers_count: 2, solutions_count: 2)

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

  context "with a v2 import" do
    let_it_be(:strategy) { :v2 }
    let_it_be(:solution_import, refind: true) { FactoryBot.create(:solution_import, strategy) }

    before do
      stub_urls_for! SolutionProperty.find("logo")
    end

    context "when given valid inputs" do
      it "is supported" do
        expect do
          perform_enqueued_jobs do
            expect_calling_with(solution_import).to succeed
          end
        end.to change { solution_import.current_state(force_reload: true) }.from("pending").to("success")
          .and change(Solution.unpublished, :count).by(59)
          .and change(SolutionDraft.in_review, :count).by(59)
          .and keep_the_same(Solution.published, :count)
          .and keep_the_same(SolutionDraft.approved, :count)
          .and change(Provider, :count).by(53)

        aggregate_failures do
          expect(solution_import).to have_attributes(providers_count: 53, solutions_count: 59)

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

  context "with a legacy import" do
    let_it_be(:strategy) { :legacy }
    let_it_be(:solution_import, refind: true) { FactoryBot.create(:solution_import, strategy) }

    context "when given valid inputs" do
      it "will process and import providers and solutions" do
        expect do
          expect_calling_with(solution_import).to succeed
        end.to change { solution_import.current_state(force_reload: true) }.from("pending").to("invalid")
          .and keep_the_same(Provider, :count)
          .and keep_the_same(Solution, :count)
          .and keep_the_same(SolutionDraft, :count)

        aggregate_failures do
          expect(solution_import).to have_attributes(providers_count: 0, solutions_count: 0)

          expect(solution_import.messages).to be_present
        end
      end
    end
  end
end
