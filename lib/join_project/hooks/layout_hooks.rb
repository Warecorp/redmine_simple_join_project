module JoinProject
  module Hooks
    class LayoutHooks < Redmine::Hook::ViewListener
      def view_layouts_base_sidebar(context={})
        project = context[:project]
        return '' if project.nil?
        return '' if User.current.member_of?(project)
        return '' if ProjectJoinRequest.pending_request_for?(User.current, project)

        return context[:controller].send(:render_to_string, :partial => 'join_projects/request_to_join_sidebar', :locals => {:project => project})
      end
    end
  end
end
