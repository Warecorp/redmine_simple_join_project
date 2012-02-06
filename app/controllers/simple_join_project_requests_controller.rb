class SimpleJoinProjectRequestsController < ApplicationController
  unloadable
  before_filter :require_login
  before_filter :find_project, :except => [:index]
  before_filter :authorize, :except => [:index]
  before_filter :authorize_global, :only => [:index]

  def index
    @simple_join_requests = ProjectSimpleJoinRequest.pending_requests_to_manage
  end
  
  def create
    @simple_join_request = ProjectSimpleJoinRequest.create_request(User.current, @project)
    respond_to do |format|
      unless @simple_join_request.new_record?
        flash[:notice] = l(:simple_join_project_successful_request)
        format.html { redirect_back_or_default(:controller => 'projects', :action => 'show', :id => @project) }
      else
        flash[:error] = l(:simple_join_project_error_cant_simple_join)
        format.html { redirect_back_or_default(:controller => 'projects', :action => 'show', :id => @project) }
      end
    end
  end

  def accept
    @simple_join_request = ProjectSimpleJoinRequest.find(params[:id])
    
    respond_to do |format|
      if @simple_join_request.accept!
        flash[:notice] = l(:notice_successful_create)
        format.html {redirect_back_or_default(:controller => 'projects', :action => 'show', :id => @project) }
      else
        flash[:error] = l(:simple_join_project_error_cant_join)
        format.html {redirect_back_or_default(:controller => 'projects', :action => 'show', :id => @project) 
      end
    end
  end

  def decline
    @simple_join_request = ProjectSimpleJoinRequest.find(params[:id])
    
    respond_to do |format|
      if @simple_join_request.decline!
        flash[:notice] = l(:simple_join_project_successful_decline)
        format.html {redirect_back_or_default(:controller => 'projects', :action => 'show', :id => @project) }
      else
        flash[:error] = l(:simple_join_project_error_cant_simple_join)
        format.html {redirect_back_or_default(:controller => 'projects', :action => 'show', :id => @project) }
      end
    end
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
