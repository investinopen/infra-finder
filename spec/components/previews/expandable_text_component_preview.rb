# frozen_string_literal: true

class ExpandableTextComponentPreview < ViewComponent::Preview
  def default
    render(ExpandableTextComponent.new)
  end
end
