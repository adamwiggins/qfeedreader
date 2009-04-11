ActionController::Routing::Routes.draw do |map|
  map.resource :feeds

  map.root :controller => 'feeds'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
