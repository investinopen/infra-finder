# frozen_string_literal: true

RSpec.describe "Admin Solutions", type: :request, default_auth: true do
  describe "GET /admin/solutions" do
    let_it_be(:extra_solutions) { FactoryBot.create_list :solution, 3 }

    def make_the_request!
      expect do
        get admin_solutions_path
      end.to execute_safely
    end

    it "is visible to super admins" do
      sign_in super_admin

      make_the_request!

      expect(response).to have_http_status(:ok)
    end

    it "is visible to admins" do
      sign_in admin

      make_the_request!

      expect(response).to have_http_status(:ok)
    end

    it "is visible to editors" do
      sign_in editor

      make_the_request!

      expect(response).to have_http_status(:ok)
    end

    it "is hidden from users" do
      sign_in regular_user

      make_the_request!

      expect(response).to redirect_to(unauthorized_path)
    end

    context "when fetching CSV" do
      def make_the_request!
        expect do
          get admin_solutions_path(format: :csv)
        end.to execute_safely
      end

      it "is visible to super admins" do
        sign_in super_admin

        make_the_request!

        expect(response).to have_http_status(:ok)
      end

      it "is visible to admins" do
        sign_in admin

        make_the_request!

        expect(response).to have_http_status(:ok)
      end

      it "is visible to editors" do
        sign_in editor

        make_the_request!

        expect(response).to redirect_to(unauthorized_path)
      end

      it "is hidden from users" do
        sign_in regular_user

        make_the_request!

        expect(response).to redirect_to(unauthorized_path)
      end
    end
  end

  describe "GET /admin/solutions/fetch_public.csv" do
    let_it_be(:extra_solutions) { FactoryBot.create_list :solution, 3 }

    def make_the_request!
      expect do
        get fetch_public_admin_solutions_path(format: :csv)
      end.to execute_safely
    end

    it "is visible to super admins" do
      sign_in super_admin

      make_the_request!

      expect(response).to have_http_status(:ok)
    end

    it "is visible to admins" do
      sign_in admin

      make_the_request!

      expect(response).to have_http_status(:ok)
    end

    it "is hidden from editors" do
      sign_in editor

      make_the_request!

      expect(response).to redirect_to(unauthorized_path)
    end

    it "is hidden from users" do
      sign_in regular_user

      make_the_request!

      expect(response).to redirect_to(unauthorized_path)
    end
  end

  describe "GET /admin/solutions/:id" do
    def make_the_request!
      expect do
        get admin_solution_path(solution)
      end.to execute_safely
    end

    it "is visible to super admins" do
      sign_in super_admin

      make_the_request!

      expect(response).to have_http_status(:ok)
    end

    it "is visible to admins" do
      sign_in admin

      make_the_request!

      expect(response).to have_http_status(:ok)
    end

    it "is visible to assigned editors" do
      sign_in editor

      make_the_request!

      expect(response).to have_http_status(:ok)
    end

    it "is hidden from unassigned editors" do
      sign_in editor

      other_solution = FactoryBot.create :solution

      expect do
        get admin_solution_path(other_solution)
      end.to execute_safely

      expect(response).to have_http_status(:not_found)
    end

    it "is hidden from users" do
      sign_in regular_user

      make_the_request!

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /admin/solutions/:id/edit" do
    def make_the_request!
      expect do
        get edit_admin_solution_path(solution)
      end.to execute_safely
    end

    it "is visible to super admins" do
      sign_in super_admin

      make_the_request!

      expect(response).to have_http_status(:ok)
    end

    it "is visible to admins" do
      sign_in admin

      make_the_request!

      expect(response).to have_http_status(:ok)
    end

    it "is hidden to assigned editors" do
      sign_in editor

      make_the_request!

      expect(response).to redirect_to(unauthorized_path)
    end

    it "is hidden from unassigned editors" do
      sign_in editor

      other_solution = FactoryBot.create :solution

      expect do
        get edit_admin_solution_path(other_solution)
      end.to execute_safely

      expect(response).to have_http_status(:not_found)
    end

    it "is hidden from users" do
      sign_in regular_user

      make_the_request!

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PUT /admin/solutions/:id/create_draft" do
    let(:request_path) { create_draft_admin_solution_path(solution) }

    let(:success_path) do
      admin_solution_solution_draft_path(solution, SolutionDraft.latest)
    end

    def expect_request_to_work!
      expect do
        put request_path
      end.to change(SolutionDraft, :count).by(1)

      expect(response).to redirect_to(success_path)
    end

    def expect_request_to_fail!
      expect do
        put request_path
      end.to keep_the_same(SolutionDraft, :count)
    end

    it "is usable by a super admin" do
      sign_in super_admin

      expect_request_to_work!
    end

    it "is usable by an admin" do
      sign_in admin

      expect_request_to_work!
    end

    it "is usable by an assigned editor" do
      sign_in editor

      expect_request_to_work!
    end

    it "is not usable by an unassigned editor" do
      other_solution = FactoryBot.create(:solution)

      # sanity check
      expect do
        other_solution.assign_editor!(regular_user)
      end.to change { regular_user.reload.kind }.from("default").to("editor")

      sign_in regular_user

      expect_request_to_fail!

      expect(response).to have_http_status(:not_found)
    end

    it "is not usable by a regular user" do
      sign_in regular_user

      expect_request_to_fail!

      expect(response).to have_http_status(:not_found)
    end

    context "when a pending draft already exists" do
      let_it_be(:solution_draft) { solution.create_draft!(user: editor) }

      it "redirects to their existing draft" do
        sign_in editor

        expect_request_to_fail!

        expect(response).to redirect_to(admin_solution_solution_draft_path(solution, solution_draft))
      end
    end
  end

  describe "POST /admin/solutions/batch_action" do
    let_it_be(:published_solution, refind: true) { FactoryBot.create :solution, :published }
    let_it_be(:unpublished_solution, refind: true) { FactoryBot.create :solution, :unpublished }

    def batch_action!(batch_action, *collection_selection)
      collection_selection.flatten!

      post batch_action_admin_solutions_path, params: { batch_action:, collection_selection:, }
    end

    shared_examples_for "valid batch publication actions" do
      describe "publish_all" do
        it "publishes unpublished solutions" do
          expect do
            batch_action!("publish_all", published_solution.id, unpublished_solution.id)
          end.to keep_the_same { published_solution.reload.published_at }
            .and keep_the_same { published_solution.reload.publication }
            .and change { unpublished_solution.reload.published_at }.from(nil).to(a_kind_of(Time))
            .and change { unpublished_solution.reload.publication }.from("unpublished").to("published")
        end
      end

      describe "unpublish_all" do
        it "unpublishes published solutions" do
          expect do
            batch_action!("unpublish_all", published_solution.id, unpublished_solution.id)
          end.to keep_the_same { unpublished_solution.reload.published_at }
            .and keep_the_same { unpublished_solution.reload.publication }
            .and change { published_solution.reload.published_at }.from(a_kind_of(Time)).to(nil)
            .and change { published_solution.reload.publication }.from("published").to("unpublished")
        end
      end
    end

    shared_examples_for "forbidden batch publication actions" do
      describe "publish_all" do
        it "publishes unpublished solutions" do
          expect do
            batch_action!("publish_all", published_solution.id, unpublished_solution.id)
          end.to keep_the_same { published_solution.reload.published_at }
            .and keep_the_same { published_solution.reload.publication }
            .and keep_the_same { unpublished_solution.reload.published_at }
            .and keep_the_same { unpublished_solution.reload.publication }

          expect(response).to have_http_status(:forbidden)
        end
      end

      describe "unpublish_all" do
        it "unpublishes published solutions" do
          expect do
            batch_action!("unpublish_all", published_solution.id, unpublished_solution.id)
          end.to keep_the_same { unpublished_solution.reload.published_at }
            .and keep_the_same { unpublished_solution.reload.publication }
            .and keep_the_same { published_solution.reload.published_at }
            .and keep_the_same { published_solution.reload.publication }

          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context "as a super admin" do
      before do
        sign_in super_admin
      end

      include_examples "valid batch publication actions"
    end

    context "as an admin" do
      before do
        sign_in admin
      end

      include_examples "valid batch publication actions"
    end

    context "as an editor" do
      before do
        sign_in editor
      end

      include_examples "forbidden batch publication actions"
    end

    context "as a regular user" do
      before do
        sign_in regular_user
      end

      include_examples "forbidden batch publication actions"
    end
  end
end
