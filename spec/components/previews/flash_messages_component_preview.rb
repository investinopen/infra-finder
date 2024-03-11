# frozen_string_literal: true

class FlashMessagesComponentPreview < ViewComponent::Preview
  def kitchen_sink
    flash = ActionDispatch::Flash::FlashHash.new
    flash[:success] = "Test Success"
    flash[:error] = "Test Error"
    flash[:warning] = "Test Warning"
    flash[:notice] = "Test Notice"
    flash[:other] = "Test Other"

    render FlashMessagesComponent.new(flash:)
  end
end
