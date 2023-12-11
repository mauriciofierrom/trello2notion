# frozen_string_literal: true

module Trello2Notion
  module Notion
    # Abstract class for Notion parent resources
    class Parent
      include JsonConvertible

      attr_accessor :type

      def initialize(**rest)
        post_init(**rest) if rest
      end

      def local_to_h
        {
          type: @type
        }.merge parent_to_h
      end

      def post_init(**_args)
        nil
      end

      def parent_to_h
        raise NotImplementedError, "Class #{self.class} must implement local_to_h"
      end
    end

    # Class for Notion Workspace parent
    class WorkspaceParent < Parent
      def post_init(**_args)
        @type = :workspace
      end

      def parent_to_h
        {
          workspace: true
        }
      end
    end

    # Class for Notion Page parent
    class PageParent < Parent
      attr_accessor :page_id

      def post_init(page_id:)
        @type = :page_id
        @page_id = page_id
      end

      def parent_to_h
        {
          page_id: @page_id
        }
      end
    end
  end
end
