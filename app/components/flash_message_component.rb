# frozen_string_literal: true

# Render flash / notice messages in the system.
class FlashMessageComponent < ApplicationComponent
  # @return [Symbol]
  attr_reader :type

  # @return [String]
  attr_reader :message

  # @param [Symbol, String] type
  # @param [String] message
  def initialize(type:, message:)
    @type = type.to_sym
    @message = message
  end

  private

  def color_classes
    case type
    when :success
      "bg-brand-mint-tint"
    when :error, :alert
      "bg-brand-orange-tint"
    when :warning
      "bg-brand-yellow-tint"
    when :notice
      "bg-brand-blue-tint"
    else
      "bg-neutral-30"
    end
  end
end
