# frozen_string_literal: true

class IntakeFormSectionComponentPreview < ViewComponent::Preview
  def default
    render(IntakeFormSectionComponent.new(title: "About your solution")) do
      safe_join([
                  render(FormFieldWrapperComponent.new(description: "Your full name")) do
                    "<label>Name</label><input type='text'>".html_safe
                  end,
                  render(FormFieldWrapperComponent.new(description: "Homepage URL")) do
                    "<label>URL</label><input type='url'>".html_safe
                  end
                ])
    end
  end
end
