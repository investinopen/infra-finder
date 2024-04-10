# frozen_string_literal: true

class SubnavBarComponentPreview < ViewComponent::Preview
  def default
    render(SubnavBarComponent.new)
  end
end
