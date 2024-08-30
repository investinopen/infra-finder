# frozen_string_literal: true

RSpec.describe UnsubscriptionsController, type: :request do
  let_it_be(:user, refind: true) { FactoryBot.create :user }

  describe "GET /unsubscribe/:kind?token=" do
    let(:kind) { "all" }
    let(:token) { nil }

    def perform_the_request!
      get unsubscribe_url(kind, token:)
    end

    shared_examples_for "an invalid request" do
      it "handles the invalid value sanely" do
        expect do
          perform_the_request!
        end.to keep_the_same { user.reload.comment_notifications }
          .and keep_the_same { user.reload.comment_notifications_updated_at }
          .and keep_the_same { user.reload.reminder_notifications }
          .and keep_the_same { user.reload.reminder_notifications_updated_at }
          .and keep_the_same(SubscriptionTransition, :count)

        aggregate_failures do
          expect(flash[:alert]).to be_present
          expect(flash[:notice]).to be_blank
          expect(response).to redirect_to solutions_url
        end
      end
    end

    context "with an empty user token" do
      let(:token) { nil }

      include_examples "an invalid request"
    end

    context "with an unknown user token" do
      let(:token) { "1234" }

      include_examples "an invalid request"
    end

    context "when kind = :some_unknown_value" do
      let(:kind) { "some_unknown_value" }

      include_examples "an invalid request"
    end

    context "when kind = :comment_notifications against a subscribed user" do
      before do
        user.subscribed_to_comment_notifications!
        user.subscribed_to_reminder_notifications!
      end

      let(:kind) { "comment_notifications" }
      let(:token) { user.unsubscribe_token }

      it "unsubscribes the user only from comment_notifications" do
        expect do
          perform_the_request!
        end.to change { user.reload.comment_notifications }.from("subscribed").to("unsubscribed")
          .and change { user.reload.comment_notifications_updated_at }
          .and keep_the_same { user.reload.reminder_notifications }
          .and keep_the_same { user.reload.reminder_notifications_updated_at }
          .and change(SubscriptionTransition, :count).by(1)

        aggregate_failures do
          expect(flash[:alert]).to be_blank
          expect(flash[:notice]).to match(/unsubscribed/i)
          expect(response).to redirect_to solutions_url
        end
      end
    end

    context "when kind = :all against a partially-subscribed user" do
      before do
        user.subscribed_to_comment_notifications!
      end

      let(:kind) { "all" }
      let(:token) { user.unsubscribe_token }

      it "unsubscribes the user" do
        expect do
          perform_the_request!
        end.to change { user.reload.comment_notifications }.from("subscribed").to("unsubscribed")
          .and change { user.reload.comment_notifications_updated_at }
          .and keep_the_same { user.reload.reminder_notifications }
          .and keep_the_same { user.reload.reminder_notifications_updated_at }
          .and change(SubscriptionTransition, :count).by(1)

        aggregate_failures do
          expect(flash[:alert]).to be_blank
          expect(flash[:notice]).to match(/unsubscribed/i)
          expect(response).to redirect_to solutions_url
        end
      end
    end
  end
end
