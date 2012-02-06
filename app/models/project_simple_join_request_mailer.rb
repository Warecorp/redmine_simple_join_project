class ProjectSimpleJoinRequestMailer < Mailer

  def simple_join_request(project_join_request)
    
    users = project_simple_join_request.project.notified_users.collect do |user|
      if user.allowed_to?(:approve_project_simple_join_requests, project_simple_join_request.project)
        user.mail unless user.pref.block_simple_join_project_requests?
      end
    end.compact

    recipients users
    subject "[#{project_simple_join_request.project.name}] #{l(:simple_join_project_text_request_to_simple_join)}"

    body({:project_simple_join_request => project_simple_join_request})
    render_multipart('simple_join_request', body)
  end

  def declined_request(project_simple_join_request)
    recipients project_simple_join_request.user.mail
    subject "[#{project_simple_join_request.project.name}] #{l(:simple_join_project_text_declined_request_to_simple_join_this_project)}"
    
    body({:project_simple_join_request => project_simple_join_request})
    render_multipart('declined_request', body)
  end
end
