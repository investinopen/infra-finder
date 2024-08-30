# frozen_string_literal: true

class UnsubscribeNoticeComponent < ApplicationComponent
  # @return [String]
  attr_reader :description

  # @return [Boolean]
  attr_reader :include_all

  alias include_all? include_all

  # @return [SubscriptionOptions::Instance]
  attr_reader :instance

  # @return [String]
  attr_reader :url

  # @return [User]
  attr_reader :user

  delegate :kind, to: :instance

  def initialize(user:, kind:)
    @user = user
    @instance = user.subscription_instance_for!(kind)
    @description = instance.i18n_description
    @include_all = kind != :all
  end
end
