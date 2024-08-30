# frozen_string_literal: true

RSpec.describe UnsubscribeNoticeComponent, type: :component do
  let_it_be(:user) { FactoryBot.create :user }

  def render_for_kind(kind, user: self.user)
    render_inline(described_class.new(user:, kind:))
  end

  it "renders only a single link when kind: :all" do
    expect(render_for_kind(:all).css(?a).count).to eq 1
  end

  it "renders multiple links for comment_notifications" do
    expect(render_for_kind(:comment_notifications).css(?a).count).to eq 3
  end

  it "renders multiple links for solution_notifications" do
    expect(render_for_kind(:solution_notifications).css(?a).count).to eq 3
  end
end
