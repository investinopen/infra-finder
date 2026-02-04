# frozen_string_literal: true

RSpec.describe CommentNotificationsMailer, type: :mailer do
  describe "#created" do
    let_it_be(:solution) { FactoryBot.create(:solution) }
    let_it_be(:author) { FactoryBot.create(:user) }
    let_it_be(:recipient) { FactoryBot.create(:user) }

    let_it_be(:comment) do
      ActiveAdmin::Comment.create!(
        resource: solution,
        author:,
        body: "This is a test comment",
        namespace: "admin"
      )
    end

    let(:mail) do
      described_class.with(comment:, recipient:).created
    end

    it "renders the subject with the solution name" do
      expect(mail.subject).to include(solution.name)
    end

    it "sends to the recipient's email" do
      expect(mail.to).to eq([recipient.email])
    end

    it "sends from the default sender" do
      expect(mail.from).to be_present
    end

    it "includes the comment body" do
      expect(mail.body.encoded).to include("This is a test comment")
    end

    it "includes the author's name" do
      expect(mail.body.encoded).to include(author.name)
    end

    it "includes a link to view the comment" do
      expect(mail.body.encoded).to match(%r{/admin/solutions/#{solution.to_param}.+#{comment.id}})
    end
  end
end
