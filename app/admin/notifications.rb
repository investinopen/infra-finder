# frozen_string_literal: true

ActiveAdmin.register_page "Notifications" do
  menu priority: 50

  content do
    render partial: "form"
  end

  page_action :update_preferences, method: :post do
    notification_keys = User.subscription_options.keys

    notification_params = params.require(:user).permit(*notification_keys)

    current_user.assign_attributes(notification_params)

    if current_user.save
      redirect_to admin_dashboard_path
    else
      render partial: "form"
    end
  end
end
