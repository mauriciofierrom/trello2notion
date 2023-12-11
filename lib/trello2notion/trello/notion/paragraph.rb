# frozen_string_literal: true

require_relative "block"

module Trello2Notion
  module Notion
    # A Notion paragraph block
    class Paragraph < Block
      attr_accessor :rich_text

      def post_init(rich_text:)
        @rich_text = rich_text || []
      end

      def block_to_h
        {
          paragraph: {
            rich_text: rich_text.map(&:to_h)
          }
        }
      end
    end
  end
end
