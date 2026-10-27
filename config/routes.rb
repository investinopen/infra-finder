# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: "", path_names: { sign_in: "sign-in", sign_out: "sign-out" }, controllers: {
    confirmations: "users/confirmations",
    passwords: "users/passwords",
    sessions: "users/sessions",
    unlocks: "users/unlocks",
  }

  use_doorkeeper do
    skip_controllers :applications, :authorized_applications, :token_info
  end

  use_doorkeeper_openid_connect

  get "/oauth/logout", to: "oauth/sessions#destroy", as: :oauth_logout

  get "/admin/login", to: redirect("/sign-in")

  ActiveAdmin.routes(self)

  post "/graphql", to: "graphql#execute", as: :graphql

  mount Middleware::TusUploader, at: "/files"

  get "/graphiql", to: "graphiql#show" if Rails.env.development?

  authenticate :user, ->(user) { user.has_any_admin_access? } do
    mount GoodJob::Engine => "good_job"
  end

  resource :comparison, only: %i[show destroy]

  resources :comparison_shares, path: "comparisons/share", only: %i[show] do
    member do
      put :shared
    end
  end

  resources :solution_intakes, only: %i[show edit update], path: "intake"

  resource :solution_search, only: %i[show create destroy]

  resource :solution_sort, only: %i[show create]

  resources :solutions, only: %i[index show] do
    resource :comparison_item, path: "compare", as: :compare, only: %i[show create destroy]
  end

  resources :unsubscriptions, as: :unsubscribe, path: "unsubscribe", only: %i[show]

  get "up" => "rails/health#show", as: :rails_health_check

  root "static#root"
end
