# frozen_string_literal: true

class IntakeFormSectionComponentPreview < ViewComponent::Preview
  def default
    render(IntakeFormSectionComponent.new(title: "About your solution")) do |section|
      section.with_field { "<label>Name</label><input type='text'>".html_safe }
      section.with_field { "<label>URL</label><input type='url'>".html_safe }
    end
  end
end
