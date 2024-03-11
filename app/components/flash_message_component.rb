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
      "bg-green-100 border-green-400 text-green-700"
    when :error, :alert
      "bg-red-100 border-red-400 text-red-700"
    when :warning
      "bg-yellow-100 border-yellow-400 text-yellow-700"
    when :notice
      "bg-blue-100 border-blue-400 text-blue-700"
    else
      "bg-gray-100 border-gray-400 text-gray-700"
    end
  end
end
