Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :admins, only: [:create]
      post '/admins/login', to: 'admins#login', as: 'admin_login'
     
      resources :events, only: [:index, :show, :create]
      get '/events/:id/attendance', to: 'events#attended', as: 'event_attendance'

      get '/events/:event_id/sessions', to: 'sessions#index', as: 'get_event_sessions'
      post '/events/:event_id/sessions', to: 'sessions#create', as: 'create_event_session'
      post '/sessions/:id/subscribe', to: 'sessions#subscribe', as: 'session_subscribe'

      put 'user/:id/attend', to: 'users#attend', as: 'attend_event'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
