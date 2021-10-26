Rails.application.routes.draw do
  resources :planets
  # resources :gameworlds
  get '/gameworlds', to: 'gameworlds#index'
  get '/gameworlds/:id', to: 'gameworlds#show', as: 'gameworld'
  post '/gameworlds', to: 'gameworlds#create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
