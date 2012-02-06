class ProjectSimpleJoinRequestObserver < ActiveRecord::Observer
  unloadable
  
  def after_create(simple_join_request)
    ProjectSimpleJoinRequestMailer.deliver_simple_join_request(simple_join_request)
  end
end
