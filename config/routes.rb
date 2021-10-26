Rails.application.routes.draw do
  get '/gameworlds', to: 'gameworlds#index'
  get '/gameworlds/:id', to: 'gameworlds#show', as: 'gameworld'
  post '/gameworlds', to: 'gameworlds#create'

  get '/planets', to: 'planets#index'
  get '/planets/:id', to: 'planets#show', as: 'planet'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
