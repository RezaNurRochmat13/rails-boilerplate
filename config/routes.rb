require 'sidekiq/web'

# simple basic auth for sidekiq web (dev/prod adjust as needed)
Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(username, ENV.fetch('SIDEKIQ_WEB_USER', 'admin')) &
    ActiveSupport::SecurityUtils.secure_compare(password, ENV.fetch('SIDEKIQ_WEB_PASSWORD', 'secret'))
end

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      resources :articles

      post '/auth/login', to: 'authentication#login'
      post '/auth/register', to: 'authentication#register'

      resources :recommendations, only: %i[index]
    end
  end

  # Sidekiq config routes
  mount Sidekiq::Web => '/sidekiq' # => http://localhost:3000/sidekiq

  # Swagger config routes
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
    mount Flipper::UI.app(Flipper) => "/flipper"
  end
end
