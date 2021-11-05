Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  get '/gameworlds', to: 'gameworlds#index'
  get '/gameworlds/:id', to: 'gameworlds#show', as: 'gameworld'
  post '/gameworlds', to: 'gameworlds#create'

  get '/gameworlds_web', to: 'gameworlds_web#index'
  get '/gameworlds_web/:id', to: 'gameworlds_web#show'

  get '/planets', to: 'planets#index'
  get '/planets/:id', to: 'planets#show', as: 'planet'

  get '/planets/:id/neighbours', to: 'neighbours#index', as: 'neighbours'
  get '/planets/:id/neighbours/:neighbour_id', to: 'neighbours#show', as: 'neighbour'

  get '/planets/:id/resources', to: 'resources#index', as: 'resources'
  get '/planets/:id/resources/:resource_id', to: 'resources#show', as: 'resource'

  get '/planets/:id/minings', to: 'minings#index', as: 'minings'
  post '/planets/:id/minings', to: 'minings#create'

  get '/resource_types', to: 'resource_types#index'

  post '/planets/:planet_id/explorations', to: 'explorations#create'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
