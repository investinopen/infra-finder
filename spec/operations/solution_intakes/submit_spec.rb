# frozen_string_literal: true

RSpec.describe SolutionIntakes::Submit, type: :operation do
  let_it_be(:name) { "Test Solution" }

  let_it_be(:solution_intake, refind: true) { FactoryBot.create(:solution_intake, :notifiable, name:) }

  let_it_be(:admin_user, refind: true) do
    FactoryBot.create(:user, :with_admin, :subscribed_to_solution_notifications)
  end

  context "when pending" do
    it "submits the intake" do
      expect do
        solution_intake.submit!
      end.to execute_safely
        .and change { solution_intake.reload.state }.from("pending").to("in_review")
        .and change { solution_intake.current_state(force_reload: true) }.from("pending").to("in_review")
        .and change(SolutionIntakes::SubmittedNotifier, :count).by(1)
        .and change(SolutionIntakes::SubmittedNotifier::Notification, :count).by(1)

      expect do
        perform_enqueued_jobs
      end.to have_enqueued_job(Noticed::DeliveryMethods::Email).once

      expect do
        perform_enqueued_jobs
      end.to send_email(to: admin_user.email, subject: /ready to review/i)
    end
  end
end
