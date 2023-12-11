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
      attr_accessor :cover, :icon, :properties, :parent

      def initialize(cover = {}, icon = {}, title:, parent:, children: [])
        @title = title
        @cover = cover
        @icon = icon
        @properties = properties
        @parent = parent
        @children = children
      end

      def to_h
        {
          cover: @cover,
          icon: @icon,
          properties: PageProperties.new(@title).to_h,
          parent: @parent,
          children: @children
        }
      end

      def to_json(*)
        to_h.to_json(*)
      end
    end
  end
end
