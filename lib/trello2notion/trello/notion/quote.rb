# frozen_string_literal: true

module Trello2Notion
  module Notion
    # A Notion quote block
    class Quote < Block
      attr_accessor :rich_text, :color, :children

      def post_init(rich_text: [], color: COLOR[:default], children: [])
        @rich_text = rich_text
        @color = color
        @children = children
      end

      def local_to_h(hash)
        hash.merge(
          {
            quote: {
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
