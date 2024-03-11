# frozen_string_literal: true

class TagComponentPreview < ViewComponent::Preview
  def default
    render(TagComponent.new)
  end
end
