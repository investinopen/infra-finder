# frozen_string_literal: true

class FormFieldWrapperComponentPreview < ViewComponent::Preview
  def default
    render(FormFieldWrapperComponent.new)
  end
end
