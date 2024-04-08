# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    if current_user.has_any_admin_access?
      columns do
        column do
          panel "Drafts in Review" do
            scope = SolutionDraft.includes(:solution, :user).in_state(:in_review).reorder(updated_at: :desc)

            if scope.exists?
              table_for scope do
                column :view_draft do |r|
                  link_to r.name, admin_solution_solution_draft_path(r.solution, r.id), target: "_blank", rel: "noopener"
                end

                column :view_solution do |r|
                  link_to r.solution.name, admin_solution_path(r.solution), target: "_blank", rel: "noopener"
                end

                column :editor do |r|
                  link_to r.user.name, admin_user_path(r.user), target: "_blank", rel: "noopener"
                end

                column :updated do |r|
                  time_tag r.updated_at, "#{time_ago_in_words(r.updated_at)} ago"
                end
              end
            else
              para "None at present"
            end
          end
        end

        column do
          panel "In-progress Drafts" do
            scope = SolutionDraft.includes(:solution, :user).in_state(:pending).reorder(updated_at: :desc)

            if scope.exists?
              table_for scope do
                column :view_draft do |r|
                  link_to r.name, admin_solution_solution_draft_path(r.solution, r.id), target: "_blank", rel: "noopener"
                end

                column :view_solution do |r|
                  link_to r.solution.name, admin_solution_path(r.solution), target: "_blank", rel: "noopener"
                end

                column :editor do |r|
                  link_to r.user.name, admin_user_path(r.user), target: "_blank", rel: "noopener"
                end

                column :updated do |r|
                  time_tag r.updated_at, "#{time_ago_in_words(r.updated_at)} ago"
                end
              end
            else
              para "None at present"
            end
          end
        end
      end
    elsif current_user.editor?
      columns do
        column do
          panel "Your Pending Drafts" do
            scope = Pundit.policy_scope!(current_user, SolutionDraft.all).includes(:solution, :user).in_state(:pending).reorder(updated_at: :desc)

            if scope.exists?
              table_for scope do
                column :view_draft do |r|
                  link_to r.name, admin_solution_solution_draft_path(r.solution, r.id), target: "_blank", rel: "noopener"
                end

                column :view_solution do |r|
                  link_to r.solution.name, admin_solution_path(r.solution), target: "_blank", rel: "noopener"
                end

                column :updated do |r|
                  time_tag r.updated_at, "#{time_ago_in_words(r.updated_at)} ago"
                end
              end
            else
              para "None at present"
            end
          end
        end

        column do
          panel "Your Drafts under Review" do
            scope = Pundit.policy_scope!(current_user, SolutionDraft.all).includes(:solution, :user).in_state(:pending).reorder(updated_at: :desc)

            if scope.exists?
              table_for scope do
                column :view_draft do |r|
                  link_to r.name, admin_solution_solution_draft_path(r.solution, r.id), target: "_blank", rel: "noopener"
                end

                column :view_solution do |r|
                  link_to r.solution.name, admin_solution_path(r.solution), target: "_blank", rel: "noopener"
                end

                column :updated do |r|
                  time_tag r.updated_at, "#{time_ago_in_words(r.updated_at)} ago"
                end
              end
            else
              para "None at present"
            end
          end
        end

        column do
          panel "Your Solutions" do
            table_for Pundit.policy_scope!(current_user, Solution.all).reorder(updated_at: :desc) do
              column :name do |r|
                link_to r.name, admin_solution_path(r), target: "_blank", rel: "noopener"
              end

              column :updated do |r|
                time_tag r.updated_at, "#{time_ago_in_words(r.updated_at)} ago"
              end
            end
          end
        end
      end
    end
  end
end
