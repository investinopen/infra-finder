# frozen_string_literal: true

RSpec.shared_examples_for "a subscription option" do |kind|
  let_it_be(:option) { described_class.subscription_option_for kind }

  let_it_be(:subscribe_method) { :"subscribed_#{option.suffix}!" }

  let_it_be(:unsubscribe_method) { :"unsubscribed_#{option.suffix}!" }

  let_it_be(:record, refind: true) { FactoryBot.create described_class.factory_bot_name }

  context "when undecided / unsubscribed" do
    it "updates the timestamp when changing subscription status" do
      expect do
        record.__send__(subscribe_method)
      end.to change { record.reload.__send__(option.timestamp) }.from(nil).to(a_kind_of(ActiveSupport::TimeWithZone))
        .and change { record.reload.__send__(option.kind) }.from("unsubscribed").to("subscribed")
        .and change(described_class.__send__(:"undecided_#{kind}"), :count).by(-1)
    end
  end

  context "when subscribed" do
    before do
      record.__send__(subscribe_method)
    end

    it "updates the timestamp when changing subscription status" do
      expect do
        record.__send__(unsubscribe_method)
      end.to change { record.reload.__send__(option.timestamp) }
        .and change { record.reload.__send__(option.kind) }.from("subscribed").to("unsubscribed")
        .and keep_the_same(described_class.__send__(:"undecided_#{kind}"), :count)
    end
  end
end
