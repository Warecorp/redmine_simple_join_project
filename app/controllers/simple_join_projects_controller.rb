class SimpleJoinProjectsController < ApplicationController
  unloadable
  before_filter :require_login
  before_filter :find_project
  before_filter :authorize

  def create
    @member = @project.members.build
    @member.user = User.current
    @member.roles = Role.find(Setting.plugin_redmine_simple_join_project['roles'])
    respond_to do |format|
      if @member.save
        flash[:notice] = l(:notice_successful_create)
        format.html { redirect_back_or_default(:controller => 'projects', :action => 'show', :id => @project) }
      else
        flash[:error] = l(:simple_join_project_error_cant_simple_join)
        format.html { redirect_back_or_default(:controller => 'projects', :action => 'show', :id => @project) }
      end
    end
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
    unless @project.self_subscribe_allowed?
      render_404
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
