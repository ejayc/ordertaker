Rails.application.routes.draw do
  resources :object_state_logs, only: [:index]

  root to: "object_state_logs#index"
end
