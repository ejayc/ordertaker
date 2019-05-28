Rails.application.routes.draw do
  resources :object_state_logs, only: [:index] do
    post :import, on: :collection
  end

  root to: "object_state_logs#index"
end
