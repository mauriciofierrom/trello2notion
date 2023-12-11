# frozen_string_literal: true

module Trello2Notion
  module Notion
    # Abstract class for Notion parent resources
    class Parent
      attr_accessor :type

      def initialize(**rest)
        post_init(**rest) if rest
      end

      def to_h
        local_to_h(
          {
            type: @type
          }
        )
      end

      def post_init(**_args)
        nil
      end

      def to_json(*)
        to_h.to_json(*)
      end

      def local_to_h(_hash)
        raise NotImplementedError, "Class #{self.class} must implement local_to_h"
      end
    end

    # Class for Notion Workspace parent
    class WorkspaceParent < Parent
      def post_init(**_args)
        @type = :workspace
      end

      def local_to_h(hash)
        hash.merge(
          {
            workspace: true
          }
        )
      end
    end

    # Class for Notion Page parent
    class PageParent < Parent
      attr_accessor :page_id

      def post_init(page_id:)
        @type = :page_id
        @page_id = page_id
      end

      def local_to_h(hash)
        hash.merge(
          {
            page_id: @page_id
          }
        )
      end
    end
  end
end
