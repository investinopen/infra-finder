# frozen_string_literal: true

# @deprecated
ActiveAdmin.register SolutionEditorAssignment do
  belongs_to :solution

  menu false

  permit_params :user_id

  actions :all, except: %i[show edit update]

  config.filters = false
  config.sort_order = "updated_at_desc"

  index title: "Editors" do
    selectable_column

    column :user, sortable: false
    column :created_at
    column :updated_at

    actions
  end

  form do |f|
    semantic_errors

    f.inputs do
      f.input :user, collection: User.assignable_to(solution), include_blank: true
    end

    actions
  end
end
