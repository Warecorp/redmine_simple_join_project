module SimpleJoinProject
  module Patches
    module UserPreferencePatch
      def self.included(base)
        base.send(:include, InstanceMethods)
      end

      module InstanceMethods
        def block_simple_join_project_requests
          self[:block_simple_join_project_requests]
        end

        def block_simple_join_project_requests=(value)
          self[:block_simple_join_project_requests]=value
        end

        def block_simple_join_project_requests?
          self[:block_simple_join_project_requests].to_i > 0
        end
      end
    end
  end
end
