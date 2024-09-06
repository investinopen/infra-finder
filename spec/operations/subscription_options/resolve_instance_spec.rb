# frozen_string_literal: true

RSpec.describe SubscriptionOptions::ResolveInstance, type: :operation do
  let_it_be(:user, refind: true) { FactoryBot.create :user }

  def resolve_an_instance
    succeed.with(a_kind_of(SubscriptionOptions::Instance))
  end

  it "handles myriad options as you would expect", :aggregate_failures do
    expect_calling_with(user, :all).to resolve_an_instance
    expect_calling_with(user, :comment_notifications).to resolve_an_instance
    expect_calling_with(user, :reminder_notifications).to resolve_an_instance
    expect_calling_with(user, :solution_notifications).to resolve_an_instance
    expect_calling_with(user, :unknown_notifications).to monad_fail.with_key(:unknown_subscription_option)
    expect_calling_with(user, nil).to monad_fail.with_key(:unknown_subscription_option)
  end
end
