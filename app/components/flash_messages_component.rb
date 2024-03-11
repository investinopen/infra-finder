# frozen_string_literal: true

# Thin wrapper around {FlashMessageComponent} to provide its layout.
class FlashMessagesComponent < ApplicationComponent
  # @return [ActionDispatch::Flash::FlashHash]
  attr_reader :flash

  def initialize(flash: view_context&.flash || ActionDispatch::Flash::FlashHash.new)
    @flash = flash
  end
end
