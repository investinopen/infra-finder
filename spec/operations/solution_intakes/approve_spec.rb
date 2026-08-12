# frozen_string_literal: true

RSpec.describe SolutionIntakes::Approve, type: :operation do
  let!(:name) { "Test Solution" }

  let!(:solution_intake) { FactoryBot.create(:solution_intake, :notifiable, name:) }

  context "when in_review" do
    before do
      solution_intake.transition_to! :in_review
    end

    it "creates a new solution and approves the intake" do
      expect do
        solution_intake.approve!
      end.to execute_safely
        .and change(Solution, :count).by(1)
        .and change(SolutionIntakes::ApprovedNotifier, :count).by(1)
        .and change(SolutionIntakes::ApprovedNotifier::Notification, :count).by(1)
        .and change(Invitation.in_state(:success), :count).by(1)
        .and have_enqueued_mail(InvitationsMailer, :welcome)
        .and change { solution_intake.reload.state }.from("in_review").to("approved")
        .and change { solution_intake.current_state(force_reload: true) }.from("in_review").to("approved")

      expect do
        perform_enqueued_jobs
      end.to have_enqueued_job(Noticed::DeliveryMethods::Email).once
        .and send_email(to: solution_intake.email, subject: /invited/i)

      expect do
        perform_enqueued_jobs
      end.to send_email(to: solution_intake.email, subject: /approved/i)
    end

    context "when the invited user already exists" do
      let!(:existing_user) do
        FactoryBot.create(:user, email: solution_intake.email, name: "Existing User")
      end

      it "creates a new solution and approves the intake without sending an invitation" do
        expect(existing_user).to be_present

        expect do
          solution_intake.approve!
        end.to execute_safely
          .and change(Solution, :count).by(1)
          .and change(SolutionIntakes::ApprovedNotifier, :count).by(1)
          .and change(SolutionIntakes::ApprovedNotifier::Notification, :count).by(1)
          .and change(Invitation.in_state(:failure), :count)
          .and change { solution_intake.reload.state }.from("in_review").to("approved")
          .and change { solution_intake.current_state(force_reload: true) }.from("in_review").to("approved")

        expect do
          perform_enqueued_jobs
        end.to have_enqueued_job(Noticed::DeliveryMethods::Email).once
          .and send_no_email(to: solution_intake.email, subject: /invited/i)

        expect do
          perform_enqueued_jobs
        end.to send_email(to: solution_intake.email, subject: /approved/i)
      end
    end
  end
end
