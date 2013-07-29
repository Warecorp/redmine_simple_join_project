class ProjectJoinRequestMailer < Mailer

  def join_request(project_join_request)
    @project_join_request = project_join_request
    users = project_join_request.approvers.collect(&:mail)
    mail(to: users,
         subject: "[#{project_join_request.project.name}] #{l(:join_project_text_request_to_join_subject)}" ) do |format|
      format.text
      format.html
    end 
  end

  def declined_request(project_join_request)
    @project_join_request = project_join_request
    mail(to: project_join_request.user.mail,
         subject: "[#{project_join_request.project.name}] #{l(:join_project_text_declined_request_to_join_this_project_subject)}" ) do |format|
      format.text
      format.html
    end    
  end

  def accepted_request(project_join_request)
    @project_join_request = project_join_request
    mail(to: project_join_request.user.mail,
         subject: "[#{project_join_request.project.name}] #{l(:join_project_text_accepted_request_to_join_this_project_subject)}" ) do |format|
      format.text
      format.html
    end
  end
end
