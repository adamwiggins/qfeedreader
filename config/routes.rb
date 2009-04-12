ActionController::Routing::Routes.draw do |map|
  map.connect '/feeds/refresh_all', :controller => 'feeds', :action => 'refresh_all'
  map.resources :feeds

  map.root :controller => 'feeds'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
