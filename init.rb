require 'redmine'

require 'simple_join_project/hooks/layout_hooks'
require 'simple_join_project/hooks/my_hooks'

require 'dispatcher'
Dispatcher.to_prepare :redmine_simple_join_project do
  require_dependency 'project'
  require_dependency 'user_preference'

  UserPreference.send(:include, SimpleJoinProject::Patches::UserPreferencePatch)

  # Remove the load the observer so it's registered for each request.
  ActiveRecord::Base.observers.delete(:project_join_request_observer)
  ActiveRecord::Base.observers << :project_join_request_observer
end

Redmine::Plugin.register :redmine_simple_join_project do
  name 'Simplified Join Project'
  author 'Eric Davis & Splendeo Innovación'
  url 'https://githb.com/splendeo/redmine_join_project'
  author_url 'http://www.littlestreamsoftware.com'
  description 'A Redmine plugin to allow non-members to join a project in Redmine'
  version '0.2.0'

  requires_redmine :version_or_higher => '0.8.0'

  permission(:approve_project_join_requests, {
               :join_project_requests => [:index, :accept, :decline]
             })
  permission(:join_projects, {
               :join_projects => :create,
               :join_project_requests => :create
             }, :public => true)

  settings({
             :partial => 'settings/redmine_simple_join_project',
             :default => {
               'roles' => [],
               'email_content' => 'A user would like to join your project. To approve or deny the request, use the link below:'
             }})

  # TODO: Need the unless for the test env, it's reloading oddly
  menu(:top_menu,
       :project_join_requests,
       {:controller => 'join_project_requests', :action => 'index'},
       :caption => :join_project_text_project_join_requests,
       :if => Proc.new {
         User.current.allowed_to?(:approve_project_join_requests, nil, :global => true)
       }) unless Redmine::MenuManager.map(:top_menu).exists?(:project_join_requests)

end


