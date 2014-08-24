Rails.application.routes.draw do
  resource :github_webhooks, only: :create, defaults: { formats: :json } do
    get :ping
  end
end
