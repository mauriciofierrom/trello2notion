# frozen_string_literal: true

require_relative "../convertible"

module Trello2Notion
  module Markdown
    # A Markdown block quote
    class CodeBlock
      include Convertible

      def initialize(element)
        @element = element
      end

      # FIXME: The value field is what's needed here. Codeblocks are only
      # recognized with the 4-space start, not with the multiple ticks
      def convert
        rich_text = Trello2Notion::Notion::RichText.basic(extract_text)
        Trello2Notion::Notion::Code.new(rich_text: [rich_text])
      end
    end
  end
end
