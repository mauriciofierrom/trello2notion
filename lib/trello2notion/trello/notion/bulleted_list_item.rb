# frozen_string_literal: true

require_relative "block"

module Trello2Notion
  module Notion
    # A Notion bullet list item block
    #
    # They are independent from each other and a bullet list is just implicitly
    # a collection of items that appear sequentially
    class BulletedListItem < Block
      attr_accessor :rich_text, :color, :children

      def post_init(rich_text:, color: COLOR[:default], children: [])
        @rich_text = rich_text
        @color = color
        @children = children
      end

      def local_to_h(hash)
        hash.merge(
          {
            bulleted_list_item: {
              rich_text: @rich_text,
              color: @color,
              children: @children
            }
          }
        )
      end
    end
  end
end