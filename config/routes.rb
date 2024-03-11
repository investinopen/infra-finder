# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  resource :comparison, only: %i[show destroy]

  resource :solution_search, only: %i[create destroy]

  resources :solutions, only: %i[index show] do
    resource :comparison_item, path: "compare", as: :compare, only: %i[create destroy]
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "static#root"
end
