# frozen_string_literal: true

class TypeaheadComponentPreview < ViewComponent::Preview
  def default
    render(TypeaheadComponent.new(
             form: form_builder,
             attr: :solution_categories,
             vocab_name: "soln_cat",
             labelled_by: "solution-categories-label",
             max_items: 3,
             placeholder: "Type to search categories…",
             max_items_placeholder: "Maximum of 3 categories selected",
           ))
  end

  private

  def form_builder
    view = ApplicationController.new.view_context
    ActionView::Helpers::FormBuilder.new(:solution_intake, nil, view, {})
  end
end
