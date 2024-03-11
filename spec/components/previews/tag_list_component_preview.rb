# frozen_string_literal: true

class TagListComponentPreview < ViewComponent::Preview
  def default
    render(TagListComponent.new)
  end
end
