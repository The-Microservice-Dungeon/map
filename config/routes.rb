# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount Logs::Engine => '/logs'
  defaults format: :json do
    get '/status', to: 'status#index'

    get '/gameworlds', to: 'gameworlds#index'
    get '/gameworlds/:id', to: 'gameworlds#show', as: 'gameworld'
    post '/gameworlds', to: 'gameworlds#create'

    get '/planets', to: 'planets#index'
    get '/planets/:id', to: 'planets#show', as: 'planet'

    get '/planets/:id/neighbours', to: 'neighbours#index', as: 'neighbours'
    get '/planets/:id/neighbours/:neighbour_id', to: 'neighbours#show', as: 'neighbour'

    get '/planets/:id/resources', to: 'resources#index', as: 'resources'

    get '/planets/:id/minings', to: 'minings#index', as: 'minings'
    post '/planets/:id/minings', to: 'minings#create'
  end

  # TODO: Basic auth admin
  get '/gameworlds_web', to: 'gameworlds_web#index'
  get '/gameworlds_web/:id', to: 'gameworlds_web#show'
  get '/gameworlds_web/:id/planets/:planet_id', to: 'gameworlds_web#show_planet', as: 'gameworlds_web_planet'
  post '/gameworlds_web/:id/planets/:planet_id', to: 'gameworlds_web#set_deleted_at', as: 'set_deleted_at'
  post '/gameworlds_web', to: 'gameworlds_web#create'
  post '/gameworlds_web/:id/planets/:planet_id', to: 'gameworlds_web#replenish_resource', as: 'replenish_resource'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
