# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  authenticate :user, ->(user) { user.has_any_admin_access? } do
    mount GoodJob::Engine => "good_job"
  end

  resource :comparison, only: %i[show destroy]

  resource :solution_search, only: %i[create destroy]

  resource :solution_sort, only: %i[create]

  resources :solutions, only: %i[index show] do
    resource :comparison_item, path: "compare", as: :compare, only: %i[create destroy]
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "static#root"
end
