# frozen_string_literal: true

ActiveAdmin.register SolutionEditorAssignment do
  belongs_to :solution

  permit_params :user_id

  actions :all, except: %i[show edit update]

  config.filters = false

  index title: "Editors" do
    selectable_column

    column :user
    column :created_at
    column :updated_at

    actions
  end

  show title: :display_name do
    attributes_table do
      row :user
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    semantic_errors

    f.inputs do
      f.input :user, collection: User.assignable_to_solution(solution), include_blank: true, hint: true
    end

    actions
  end
end
