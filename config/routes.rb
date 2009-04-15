ActionController::Routing::Routes.draw do |map|
  map.connect '/feeds/refresh', :controller => 'feeds', :action => 'refresh_all', :method => 'post'
  map.resources :feeds

  map.root :controller => 'feeds'
  map.connect '/feeds/:id/refresh', :controller => 'feeds', :action => 'refresh'
end
