Rails.application.routes.draw do
  root 'memorials#index'
  
  resources :memorials do
    member do
      get :status
    end
  end
  
  get '/memorial/:slug', to: 'memorials#public', as: :public_memorial
  
  get '/up', to: proc { [200, {}, ['OK']] }
end
