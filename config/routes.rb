RedmineApp::Application.routes.draw do
  resources :join_projects, :path_prefix => '/projects/:project_id', :only => [:create], :as => 'join'
  resources :join_project_requests, :path_prefix => '/projects/:project_id', :controller => 'join_project_requests', :only => [:create, :accept, :decline], :as => 'join_project_request' do
  	member do
  	  match :accept, via: [:get, :put]
  	  match :decline, via: [:get, :put]
  	end 
  end

  resources :join_project_requests, :only => [:index]
end
