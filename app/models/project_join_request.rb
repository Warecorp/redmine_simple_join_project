class ProjectJoinRequest < ActiveRecord::Base
  unloadable
  belongs_to :user
  belongs_to :project

  validates_inclusion_of :status, :in => ['new', 'accepted', 'declined'], :allow_blank => 'true'
  validates_uniqueness_of :user_id, :scope => :project_id

  scope :status_of, ->(status) { where(status: status) }

  scope :visible_to, ->(user) {
    joins(:project).where(
      Project.allowed_to_condition(user, :approve_project_join_requests))
  }

  def accept!
    membership = project.members.build
    membership.user = user
    membership.roles = Role.find(Setting.plugin_redmine_simple_join_project['roles'])
    membership.save
    self.update_attribute(:status, 'accepted')
    ProjectJoinRequestMailer.deliver_accepted_request(self)
  end

  def decline!
    self.update_attribute(:status, 'declined')
    ProjectJoinRequestMailer.deliver_declined_request(self)
    self
  end

  def approvers
    project.users.select do |user|
      user.allowed_to?(:approve_project_join_requests, project)
    end
  end

  def self.pending_requests_to_manage(user=User.current)
    status_of('new').visible_to(user)
  end

  def self.create_request(user, project)
    ProjectJoinRequest.create(:user => user, :project => project, :status => 'new')
  end

  def self.pending_request_for?(user, project)
    ProjectJoinRequest.find_by_user_id_and_project_id(user.id, project.id)
  end

end
