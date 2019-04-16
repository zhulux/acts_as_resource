ActsAsResource::Engine.routes.draw do
  # for active resource
  get '/:resource_name', to: 'resources#index'
  get '/:resource_name/:id', to: 'resources#show'
  post '/:resource_name', to: 'resources#create'
  match '/:resource_name/:id', to: 'resources#update', via: %i[put patch]
  delete '/:resource_name/:id', to: 'resources#destroy'
end
