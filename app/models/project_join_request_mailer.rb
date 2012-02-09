class ProjectJoinRequestMailer < Mailer

  def join_request(project_join_request)

    recipients project_join_request.approvers.collect(&:mail)
    subject "[#{project_join_request.project.name}] #{l(:join_project_text_request_to_join_subject)}"

    body({:project_join_request => project_join_request})
    render_multipart('join_request', body)
  end

  def declined_request(project_join_request)
    recipients project_join_request.user.mail
    subject "[#{project_join_request.project.name}] #{l(:join_project_text_declined_request_to_join_this_project_subject)}"

    body({:project_join_request => project_join_request})
    render_multipart('declined_request', body)
  end

  def accepted_request(project_join_request)
    recipients project_join_request.user.mail
    subject "[#{project_join_request.project.name}] #{l(:join_project_text_accepted_request_to_join_this_project_subject)}"

    body({:project_join_request => project_join_request})
    render_multipart('accepted_request', body)
  end
end
