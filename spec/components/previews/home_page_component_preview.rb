# frozen_string_literal: true

class HomePageComponentPreview < ViewComponent::Preview
  def default
    render(HomePageComponent.new)
  end
end
