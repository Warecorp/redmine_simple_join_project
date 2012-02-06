module SimpleJoinProject
  module Hooks
    class LayoutHooks < Redmine::Hook::ViewListener
      def view_layouts_base_sidebar(context={})
        project = context[:project]
        return '' if project.nil? || project.new_record?
        return '' if User.current.member_of?(project)
        return '' if ProjectSimpleJoinRequest.pending_request_for?(User.current, project)

        return context[:controller].send(:render_to_string, :partial => 'simple_join_projects/request_to_simple_join_sidebar', :locals => {:project => project})
      end
    end
  end
end
