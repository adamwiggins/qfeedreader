ActionController::Routing::Routes.draw do |map|
  map.connect '/feeds/refresh', :controller => 'feeds', :action => 'refresh_all', :method => 'post'
  map.connect '/feeds/:id/refresh', :controller => 'feeds', :action => 'refresh'
  map.resources :feeds

  map.root :controller => 'feeds'
end
