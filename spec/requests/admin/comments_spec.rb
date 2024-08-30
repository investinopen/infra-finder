# frozen_string_literal: true

RSpec.describe "Admin::Comments", type: :request, default_auth: true do
  let_it_be(:other_editor, refind: true) do
    FactoryBot.create(:user, :subscribed_to_all).tap { solution.assign_editor!(_1) }
  end

  before do
    editor.subscribed_to_comment_notifications!

    admin.subscribed_to_comment_notifications!

    sign_in editor
  end

  describe "POST /admin/comments" do
    let(:body) { Faker::Lorem.paragraph }
    let(:resource) { nil }
    let(:resource_id) { resource.try(:id) }
    let(:resource_type) { resource.try(:model_name).try(:to_s) }

    let(:params) do
      {
        active_admin_comment: {
          body:,
          resource_id:,
          resource_type:,
        }
      }
    end

    def make_the_request!
      post(admin_comments_path, params:)
    end

    context "for a solution" do
      let(:resource) { solution }

      it "makes a comment and notifies those who have subscribed" do
        expect do
          make_the_request!
        end.to change(ActiveAdmin::Comment, :count).by(1)
          .and have_enqueued_mail(CommentNotificationsMailer, :created).twice
      end
    end
  end
end
