# frozen_string_literal: true

RSpec.describe "SolutionIntakes", type: :request, default_auth: true do
  let_it_be(:solution_intake, refind: true) { FactoryBot.create(:solution_intake) }

  before_all do
    InfraFinder::Container["controlled_vocabularies.upsert_all_records"].().value!
  end

  shared_context "as an admin user" do
    before do
      sign_in admin
    end
  end

  describe "GET /show" do
    shared_examples_for "a valid confirmation page" do
      it "renders the confirmation page" do
        get solution_intake_path(solution_intake.slug)

        expect(response).to have_http_status(:success)
      end
    end

    shared_examples_for "a form redirection" do
      it "redirects to the edit form" do
        get solution_intake_path(solution_intake.slug)

        expect(response).to redirect_to(edit_solution_intake_path(solution_intake.slug))
      end
    end

    shared_examples_for "a not found request" do
      it "renders a not found page" do
        get solution_intake_path(solution_intake.slug)

        expect(response).to have_http_status(:not_found)
      end
    end

    context "with a pending intake" do
      context "for an admin user", :admin_user do
        include_examples "a form redirection"
      end

      context "for an anonymous user" do
        include_examples "a form redirection"
      end
    end

    context "with an in-review intake" do
      before do
        solution_intake.transition_to! :in_review
      end

      context "for an admin user" do
        include_context "as an admin user"

        include_examples "a valid confirmation page"
      end

      context "for an anonymous user" do
        include_examples "a valid confirmation page"
      end
    end

    context "with an approved intake" do
      before do
        solution_intake.transition_to! :in_review
        solution_intake.transition_to! :approved
      end

      context "for an admin user" do
        include_context "as an admin user"

        include_examples "a valid confirmation page"
      end

      context "for an anonymous user" do
        include_examples "a not found request"
      end
    end
  end

  describe "GET /edit" do
    shared_examples_for "a valid form page" do
      it "renders the form" do
        get edit_solution_intake_path(solution_intake.slug)

        expect(response).to have_http_status(:success)
      end
    end

    shared_examples_for "a confirmation redirection" do
      it "redirects to the edit form" do
        get edit_solution_intake_path(solution_intake.slug)

        expect(response).to redirect_to(solution_intake_path(solution_intake.slug))
      end
    end

    shared_examples_for "a not found request" do
      it "renders a not found page" do
        get edit_solution_intake_path(solution_intake.slug)

        expect(response).to have_http_status(:not_found)
      end
    end

    context "with a pending intake" do
      context "with an anonymous user" do
        include_examples "a valid form page"
      end

      context "for an admin user" do
        include_context "as an admin user"

        include_examples "a valid form page"
      end
    end

    context "with an in-review intake" do
      before do
        solution_intake.transition_to! :in_review
      end

      context "with an anonymous user" do
        include_examples "a confirmation redirection"
      end

      context "for an admin user" do
        include_context "as an admin user"
        include_examples "a valid form page"
      end
    end

    context "with an approved intake" do
      before do
        solution_intake.transition_to! :in_review
        solution_intake.transition_to! :approved
      end

      context "with an anonymous user" do
        include_examples "a not found request"
      end

      context "for an admin user" do
        include_context "as an admin user"

        include_examples "a confirmation redirection"
      end
    end

    it "can render the edit page" do
      get edit_solution_intake_path(solution_intake.slug)

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /update" do
    let(:turbo_headers) { { "Accept" => "#{Mime[:turbo_stream]}, text/html" } }

    let!(:skip_validations) { false }

    let!(:should_transition_to_in_review) { false }

    let!(:partial_intake_params) do
      {
        first_name: "Ada",
        last_name: "Lovelace",
        email: ""
      }
    end

    let(:full_intake_params) do
      FactoryBot.attributes_for(
        :solution_intake,
        :ready_to_approve,
        name: solution_intake.name,
        first_name: "Ada",
        last_name: "Lovelace",
        email: "ada@example.com"
      )
    end

    let(:solution_intake_params) do
      partial_intake_params
    end

    def parameterize_intake_params(input)
      InfraFinder::Container["solution_intakes.parameterize"].(input)
    end

    # @return [void]
    def make_the_request!
      params = {
        skip_validations:,
        solution_intake: parameterize_intake_params(solution_intake_params),
      }

      patch(solution_intake_path(solution_intake.slug),
        params:,
        headers: turbo_headers
      )
    end

    def maybe_transition_to_in_review
      if should_transition_to_in_review
        change { solution_intake.current_state(force_reload: true) }.from("pending").to("in_review")
          .and change { solution_intake.reload.state }.from("pending").to("in_review")
      else
        keep_the_same { solution_intake.current_state(force_reload: true) }
          .and keep_the_same { solution_intake.reload.state }
      end
    end

    shared_examples_for "a forbidden draft save" do
      context "with partial params" do
        let!(:skip_validations) { true }
        let!(:solution_intake_params) { partial_intake_params }

        it "forbids the request" do
          expect do
            make_the_request!
          end.to keep_the_same { solution_intake.reload.first_name }
            .and keep_the_same { solution_intake.current_state(force_reload: true) }

          aggregate_failures do
            expect(response).to have_http_status(:forbidden)
            expect(response.media_type).to eq(Mime[:html].to_s)
          end
        end
      end
    end

    shared_examples_for "a forbidden submission" do
      context "with full params" do
        let!(:skip_validations) { false }
        let!(:solution_intake_params) { full_intake_params }

        it "forbids the request" do
          expect do
            make_the_request!
          end.to keep_the_same { solution_intake.reload.first_name }
            .and keep_the_same { solution_intake.current_state(force_reload: true) }

          aggregate_failures do
            expect(response).to have_http_status(:forbidden)
            expect(response.media_type).to eq(Mime[:html].to_s)
          end
        end
      end
    end

    shared_examples_for "a not found draft save" do
      context "with partial params" do
        let!(:skip_validations) { true }
        let!(:solution_intake_params) { partial_intake_params }

        it "returns a not found response" do
          expect do
            make_the_request!
          end.to keep_the_same { solution_intake.reload.first_name }
            .and keep_the_same { solution_intake.current_state(force_reload: true) }

          aggregate_failures do
            expect(response).to have_http_status(:not_found)
            expect(response.media_type).to eq(Mime[:html].to_s)
          end
        end
      end
    end

    shared_examples_for "a not found submission" do
      context "with full params" do
        let!(:skip_validations) { false }
        let!(:solution_intake_params) { full_intake_params }

        it "returns a not found response" do
          expect do
            make_the_request!
          end.to keep_the_same { solution_intake.reload.first_name }
            .and keep_the_same { solution_intake.current_state(force_reload: true) }

          aggregate_failures do
            expect(response).to have_http_status(:not_found)
            expect(response.media_type).to eq(Mime[:html].to_s)
          end
        end
      end
    end

    shared_examples_for "a successful draft save" do
      context "when skipping validation" do
        let!(:skip_validations) { true }
        let!(:should_transition_to_in_review) { false }

        it "patches the intake and returns a turbo stream" do
          expect do
            make_the_request!
          end.to change { solution_intake.reload.first_name }.from(nil).to("Ada")
            .and keep_the_same { solution_intake.current_state(force_reload: true) }

          aggregate_failures do
            expect(response).to have_http_status(:success)
            expect(response.media_type).to eq(Mime[:turbo_stream].to_s)
            expect(response.body).to include("flash-messages")
          end
        end
      end
    end

    shared_examples_for "a successful submission" do
      context "with full params" do
        let!(:skip_validations) { false }
        let!(:solution_intake_params) { full_intake_params }

        it "patches the intake and returns a redirect" do
          expect do
            make_the_request!
          end.to change { solution_intake.reload.first_name }.from(nil).to("Ada")
            .and maybe_transition_to_in_review

          aggregate_failures do
            expect(response).to have_http_status(:see_other)
            expect(response.media_type).to eq(Mime[:html].to_s)
            expect(response).to redirect_to(solution_intake_path(solution_intake.slug))
          end
        end
      end

      context "when partial params are provided" do
        let!(:skip_validations) { false }
        let!(:solution_intake_params) { partial_intake_params }

        it "returns an error" do
          expect do
            make_the_request!
          end.to keep_the_same { solution_intake.reload.first_name }
            .and keep_the_same { solution_intake.current_state(force_reload: true) }

          aggregate_failures do
            expect(response).to have_http_status(:unprocessable_content)
            expect(response.media_type).to eq(Mime[:html].to_s)
          end
        end
      end

      context "when no params are provided" do
        let!(:skip_validations) { false }
        let!(:solution_intake_params) { {} }

        it "returns an error" do
          expect do
            make_the_request!
          end.to keep_the_same { solution_intake.reload.first_name }
            .and keep_the_same { solution_intake.current_state(force_reload: true) }

          aggregate_failures do
            expect(response).to have_http_status(:unprocessable_content)
            expect(response.media_type).to eq(Mime[:html].to_s)
          end
        end
      end
    end

    context "with a pending intake" do
      let!(:should_transition_to_in_review) { true }

      context "for an anonymous user" do
        include_examples "a successful draft save"
        include_examples "a successful submission"
      end

      context "for an admin user" do
        include_context "as an admin user"

        include_examples "a successful draft save"
        include_examples "a successful submission"
      end
    end

    context "with an in-review intake" do
      let!(:should_transition_to_in_review) { false }

      before do
        solution_intake.transition_to! :in_review
      end

      context "for an anonymous user" do
        include_examples "a forbidden draft save"
        include_examples "a forbidden submission"
      end

      context "for an admin user" do
        include_context "as an admin user"

        include_examples "a successful draft save"
        include_examples "a successful submission"
      end
    end

    context "with an approved intake" do
      before do
        solution_intake.transition_to! :in_review
        solution_intake.transition_to! :approved
      end

      context "for an anonymous user" do
        include_examples "a not found draft save"
        include_examples "a not found submission"
      end

      context "for an admin user" do
        include_context "as an admin user"

        include_examples "a forbidden draft save"
        include_examples "a forbidden submission"
      end
    end

    context "with a rejected intake" do
      before do
        solution_intake.transition_to! :in_review
        solution_intake.transition_to! :rejected
      end

      context "for an anonymous user" do
        include_examples "a not found draft save"
        include_examples "a not found submission"
      end

      context "for an admin user" do
        include_context "as an admin user"

        include_examples "a forbidden draft save"
        include_examples "a forbidden submission"
      end
    end
  end
end
