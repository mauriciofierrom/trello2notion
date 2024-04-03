# frozen_string_literal: true

module Trello2Notion
  module Notion
    # A struct for Notion page properties
    #
    # We only support the title for now because we'll always have either a
    # 'workspace' or another page as the parent (for now)
    PageProperties = Struct.new(:title)

    # A class for a Notion page
    class Page
      include JsonConvertible

      attr_accessor :cover, :icon, :properties, :parent, :children

      def initialize(cover = {}, icon = {}, title:, parent:, children: [])
        @title = title
        @cover = cover
        @icon = icon
        @properties = properties
        @parent = parent
        @children = children
      end

      def local_to_h
        {
          cover: @cover,
          icon: @icon,
          properties: page_title_property,
          parent: @parent,
          children: @children.map(&:to_h)
        }
      end

      private

      def page_title_property
        {
          title: [
            {
              text: {
                content: @title
              }
            }
          ]
        }
      end
    end
  end
end
