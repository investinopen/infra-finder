# frozen_string_literal: true

class FlashMessageComponentPreview < ViewComponent::Preview
  def success
    render(FlashMessageComponent.new(type: :success, message: "some message"))
  end

  def error
    render(FlashMessageComponent.new(type: :error, message: "some message"))
  end

  def alert
    render(FlashMessageComponent.new(type: :alert, message: "some message"))
  end

  def warning
    render(FlashMessageComponent.new(type: :warning, message: "some message"))
  end

  def notice
    render(FlashMessageComponent.new(type: :notice, message: "some message"))
  end

  def other
    render(FlashMessageComponent.new(type: :other, message: "some message"))
  end
end
