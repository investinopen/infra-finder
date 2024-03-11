# frozen_string_literal: true

class FooterComponentPreview < ViewComponent::Preview
  def default
    render(FooterComponent.new)
  end
end
