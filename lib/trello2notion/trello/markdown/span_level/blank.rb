# frozen_string_literal: true

module Trello2Notion
  module Markdown
    # A Notion blank line block
    class Blank
      include Convertible
      include Trello2Notion::Notion

      def initialize(element)
        @element = element
      end

      def convert
        rich_text = [RichText.empty]
        [Trello2Notion::Notion::Paragraph.new(rich_text:)]
      end
    end
  end
end
