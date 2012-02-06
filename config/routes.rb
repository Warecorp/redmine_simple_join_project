ActionController::Routing::Routes.draw do |map|
  map.resources :simple_join_projects, :path_prefix => '/projects/:project_id', :only => [:create], :as => 'simple_join'
  map.resources :simple_join_project_requests, :path_prefix => '/projects/:project_id', :controller => 'simple_join_project_requests', :only => [:create, :accept, :decline], :as => 'simple_join_request', :member => {:accept => [:get, :put], :decline => [:get, :put]}
  map.resources :simple_join_project_requests, :only => [:index]
end
