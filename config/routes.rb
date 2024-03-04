# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  resources :solutions

  get "up" => "rails/health#show", as: :rails_health_check

  root "static#root"
end
