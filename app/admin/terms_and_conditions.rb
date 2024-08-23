# frozen_string_literal: true

ActiveAdmin.register_page "terms_and_conditions" do
  menu false

  controller do
    before_action :bypass_duplicate!, on: %i[accept show]

    # @return [void]
    def bypass_duplicate!
      return unless current_user.accepted_terms?

      redirect_back fallback_location: admin_dashboard_path
    end
  end

  content title: "Terms And Conditions" do
    render partial: "form"
  end

  page_action :accept, method: :post do
    term_params = params.require(:user).permit(:accept_terms_and_conditions)

    current_user.assign_attributes(term_params)

    if current_user.save(context: :accepting_terms)
      redirect_to admin_dashboard_path
    else
      render partial: "form"
    end
  end
end
