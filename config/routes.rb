# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  authenticate :user, ->(user) { user.has_any_admin_access? } do
    mount GoodJob::Engine => "good_job"
  end

  resource :comparison, only: %i[show destroy]

  resources :comparison_shares, path: "comparisons/share", only: %i[show] do
    member do
      put :shared
    end
  end

  resource :solution_search, only: %i[show create destroy]

  resource :solution_sort, only: %i[show create]

  resources :solutions, only: %i[index show] do
    resource :comparison_item, path: "compare", as: :compare, only: %i[create destroy]
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "static#root"
end
