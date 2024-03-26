# frozen_string_literal: true

# Thin wrapper around {FlashMessageComponent} to provide its layout.
class FlashMessagesComponent < ApplicationComponent
  # @return [ActionDispatch::Flash::FlashHash]
  attr_reader :flash

  def initialize(flash: view_context&.flash || ActionDispatch::Flash::FlashHash.new)
    @flash = flash
  end

  private

  def each_flash
    return enum_for(__method__) unless block_given?

    flash.each do |type, message|
      next unless acceptable?(message)

      type = type.to_sym

      yield type, message
    end
  end

  def has_acceptable_flash?
    each_flash.any?
  end

  def acceptable?(message)
    message.present? && message.kind_of?(String) && !weird?(message)
  end

  def weird?(message)
    message.match?(/true/i)
  end
end
